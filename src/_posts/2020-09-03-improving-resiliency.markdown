---
layout: post
title: "Improving Apache Cassandra’s Front Door and Backpressure"
date:   2020-09-03 09:00:00 0200
author: the Apache Cassandra Community
categories: blog
---

As part of [CASSANDRA-15013](https://issues.apache.org/jira/browse/CASSANDRA-15013), we have improved Cassandra’s ability to handle high throughput workloads, while having enough safeguards in place to protect itself from potentially going out of memory. In order to better explain the change we have made, let us understand at a high level, on how an incoming request is processed by Cassandra before the fix, followed by what we changed, and the new relevant configuration knobs available.

### How inbound requests were handled before 

Let us take the scenario of a client application sending requests to C* cluster. For the purpose of this blog, let us focus on one of the C* coordinator nodes.

![alt_text](/img/blog-post-improving-resiliency/image1.png "image_tooltip")

Below is the microscopic view of client-server interaction at the C* coordinator node. Each client connection to Cassandra node happens over a netty channel, and for efficiency purposes, each Netty eventloop thread is responsible for more than one netty channel.

![alt_text](/img/blog-post-improving-resiliency/image2.png "image_tooltip")

The eventloop threads read requests coming off of netty channels and enqueue them into a bounded inbound queue in the Cassandra node.

![alt_text](/img/blog-post-improving-resiliency/image3.png "image_tooltip")

A thread pool dequeues requests from the inbound queue, processes them asynchronously and enqueues the response into an outbound queue. There exist multiple outbound queues, one for each eventloop thread to avoid races.

![alt_text](/img/blog-post-improving-resiliency/image4.png "image_tooltip")

![alt_text](/img/blog-post-improving-resiliency/image5.png "image_tooltip")

![alt_text](/img/blog-post-improving-resiliency/image6.png "image_tooltip")

The same eventloop threads that are responsible for enqueuing incoming requests into the inbound queue, are also responsible for dequeuing responses off from the outbound queue and shipping responses back to the client.

![alt_text](/img/blog-post-improving-resiliency/image7.png "image_tooltip")

![alt_text](/img/blog-post-improving-resiliency/image8.png "image_tooltip")

#### Issue with this workflow

Let us take a scenario where there is a spike in operations from the client. The eventloop threads are now enqueuing requests at a much higher rate than the rate at which the requests are being processed by the native transport thread pool. Eventually, the inbound queue reaches its limit and says it cannot store any more requests in the queue.

![alt_text](/img/blog-post-improving-resiliency/image9.png "image_tooltip")

Consequently, the eventloop threads get into a blocked state as they try to enqueue more requests into an already full inbound queue. They wait until they can successfully enqueue the request in hand, into the queue.

![alt_text](/img/blog-post-improving-resiliency/image10.png "image_tooltip")

As noted earlier, these blocked eventloop threads are also supposed to dequeue responses from the outbound queue. Given they are in blocked state, the outbound queue (which is unbounded) grows endlessly, with all the responses, eventually resulting in C*  going out of memory. This is a vicious cycle because, since the eventloop threads are blocked, there is no one to ship responses back to the client; eventually client side timeout triggers, and clients may send more requests due to retries. This is an unfortunate situation to be in, since Cassandra is doing all the work of processing these requests as fast as it can, but there is no one to ship the produced responses back to the client.

![alt_text](/img/blog-post-improving-resiliency/image11.png "image_tooltip")

So far, we have built a fair understanding of how the front door of C* works with regard to handling client requests, and how blocked eventloop threads can affect Cassandra.

### What we changed

#### Backpressure

The essential root cause of the issue is that eventloop threads are getting blocked. Let us not block them by making the bounded inbound queue unbounded. If we are not careful here though, we could have an out of memory situation, this time because of the unbounded inbound queue. So we defined an overloaded state for the node based on the memory usage of the inbound queue.

We introduced two levels of thresholds, one at the node level, and the other more granular, at client IP. The one at client IP helps to isolate rogue client IPs, while not affecting other good clients, if there is such a situation. 

These thresholds can be set using cassandra yaml file.

```
native_transport_max_concurrent_requests_in_bytes_per_ip
native_transport_max_concurrent_requests_in_bytes
```

These thresholds can be further changed at runtime ([CASSANDRA-15519](https://issues.apache.org/jira/browse/CASSANDRA-15519)).

#### Configurable server response to the client as part of backpressure

If C* happens to be in overloaded state (as defined by the thresholds mentioned above), C* can react in one of the following ways:

*   Apply backpressure by setting “Autoread” to false on the netty channel in question (default behavior).
*   Respond back to the client with Overloaded Exception (if client sets “THROW_ON_OVERLOAD” connection startup option to “true.”

Let us look at the client request-response workflow again, in both these cases.

#### **THROW_ON_OVERLOAD = false (default)**

If the inbound queue is full (i.e. the thresholds are met).

![alt_text](/img/blog-post-improving-resiliency/image12.png "image_tooltip")

C* sets autoread to false on the netty channel, which means it will stop reading bytes off of the netty channel.

![alt_text](/img/blog-post-improving-resiliency/image13.png "image_tooltip")

Consequently, the kernel socket inbound buffer becomes full since no bytes are being read off of it by netty eventloop.

![alt_text](/img/blog-post-improving-resiliency/image14.png "image_tooltip")

Once the Kernel Socket Inbound Buffer is full on the server side, things start getting piled up in the Kernel Socket Outbound Buffer on the client side, and once this buffer gets full, client will start experiencing backpressure.

![alt_text](/img/blog-post-improving-resiliency/image15.png "image_tooltip")

#### **THROW_ON_OVERLOAD = true**

If the inbound queue is full (i.e. the thresholds are met), eventloop threads do not enqueue the request into the Inbound Queue. Instead, the eventloop thread creates an OverloadedException response message and enqueues it into the flusher queue, which will then be shipped back to the client.

![alt_text](/img/blog-post-improving-resiliency/image16.png "image_tooltip")

This way, Cassandra is able to serve very large throughput, while protecting itself from getting into memory starvation issues. This patch has been vetted through thorough performance benchmarking. Detailed performance analysis can be found [here](https://issues.apache.org/jira/browse/CASSANDRA-15013?focusedCommentId=16881762&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-16881762). 
