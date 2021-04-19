---
layout: post
title: "Even Higher Availability with 5x Faster Streaming in Cassandra 4.0"
date:   2019-04-09 01:00:00 -0700
author: The Apache Cassandra Community
categories: blog
---

Streaming is a process where nodes of a cluster exchange data in the form of SSTables. Streaming can kick in during many situations such as bootstrap, repair, rebuild, range movement, cluster expansion, etc. In this post, we discuss the massive performance improvements made to the streaming process in Apache Cassandra 4.0.

## High Availability
As we know Cassandra is a Highly Available, Eventually Consistent database. The way it maintains its legendary availability is by storing redundant copies of data in nodes known as replicas, usually running on commodity hardware. During normal operations, these replicas may end up having hardware issues causing them to fail. As a result, we need to replace them with new nodes on fresh hardware.

As part of this replacement operation, the new Cassandra node streams data from the neighboring nodes that hold copies of the data belonging to this new node’s token range. Depending on the amount of data stored, this process can require substantial network bandwidth, taking some time to complete. The longer these types of operations take, the more we are exposing ourselves to loss of availability. Depending on your replication factor and consistency requirements, if another node fails during this replacement operation, ability will be impacted.  

## Increasing Availability
To minimize the failure window, we want to make these operations as fast as possible. The faster the new node completes streaming its data, the faster it can serve traffic, increasing the availability of the cluster. Towards this goal, Cassandra 4.0 saw the addition of [Zero Copy](https://en.wikipedia.org/wiki/Zero-copy) streaming. For more details on Cassandra's zero copy implementation, see this <a href="../../../2018/08/07/faster_streaming_in_cassandra.html">blog post</a> and [CASSANDRA-14556](https://issues.apache.org/jira/browse/CASSANDRA-14556) for more information.

## Talking Numbers
To quantify the results of these improvements, we, at Netflix, measured the performance impact of streaming in 4.0 vs 3.0, using our open source [NDBench](https://github.com/Netflix/ndbench) benchmarking tool with the CassJavaDriverGeneric plugin. Though we knew there would be improvements, we were still amazed with the overall results of a **five fold increase** in streaming performance. The test setup and operations are all detailed below.

### Test Setup
In our test setup, we used the following configurations:
* 6-node clusters on i3.xl, i3.2xl, i3.4xl and i3.8xl EC2 instances, each on 3.0 and trunk (sha dd7ec5a2d6736b26d3c5f137388f2d0028df7a03).
* Table schema
<div><pre>
CREATE TABLE testing.test (
    key text,
    column1 int,
    value text,
    PRIMARY KEY (key, column1)
) WITH CLUSTERING ORDER BY (column1 ASC)
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.LeveledCompactionStrategy'}
    AND compression = {'enabled': 'false'}
    AND crc_check_chance = 1.0
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99PERCENTILE';
</pre></div>

* Data size per node: 500GB
* No. of tokens per node: 1 (no vnodes)

To trigger the streaming process we used the following steps in each of the clusters:
* terminated a node
* add a new node as a replacement
* measure the time taken to complete streaming data by the new node replacing the terminated node

For each cluster and version, we repeated this exercise multiple times to collect several samples.

Below is the distribution of streaming times we found across the clusters
![Benchmark results](/img/blog-post-benchmarking-streaming/cassandra_streaming.png "Benchmark results")

### Interpreting the Results
Based on the graph above, there are many conclusions one can draw from it. Some of them are
* 3.0 streaming times are inconsistent and show high degree of variability (fat distributions across multiple samples)
* 3.0 streaming is highly affected by the instance type and generally looks generally CPU bound
* Zero Copy streaming is approximately 5x faster
* Zero Copy streaming time shows little variability in its performance (thin distributions across multiple samples)
* Zero Copy streaming performance is not CPU bound and remains consistent across instance types

It is clear from the performance test results that Zero Copy Streaming has a huge performance benefit over the current streaming infrastructure in Cassandra. But what does it mean in the real world? The following key points are the main take aways.

**MTTR (Mean Time to Recovery):** MTTR is a KPI (Key Performance Indicator) that is used to measure how quickly a system recovers from a failure. Zero Copy Streaming has a very direct impact here with a **five fold improvement** on performance.

**Costs:** Zero Copy Streaming is ~5x faster. This translates directly into cost for some organizations primarily as a result of reducing the need to maintain spare server or cloud capacity. In other situations where you’re migrating data to larger instance types or moving AZs or DCs, this means that instances that are sending data can be turned off sooner saving costs. An added cost benefit is that now you don’t have to over provision the instance. You get a similar streaming performance whether you use a i3.xl or an i3.8xl provided the bandwidth is available to the instance.

**Risk Reduction:** There is a great reduction in the risk due to Zero Copy Streaming as well. Since a Cluster’s recovery mainly depends on the streaming speed, Cassandra clusters with failed nodes will be able to recover much more quickly (5x faster). This means the window of vulnerability is reduced significantly, in some situations down to few minutes.

Finally, a benefit that we generally don’t talk about is the environmental benefit of this change. Zero Copy Streaming enables us to move data very quickly through the cluster. It objectively reduces the number and sizes of instances that are used to build Cassandra cluster. As a result not only does it reduce Cassandra’s TCO (Total Cost of Ownership), it also helps the environment by consuming fewer resources!
