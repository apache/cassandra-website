---
layout: post
title: "Introducing Apache Cassandra 4.0 Beta: Battle Tested From Day One"
date:   2020-07-20 23:00:00 +0200
author: The Apache Cassandra Community
categories: blog
---


This is the most **stable** Apache Cassandra in history; you should start using Apache Cassandra 4.0 Beta today in your test and QA environments, head to the [downloads site](https://cassandra.apache.org/download/) to get your hands on it. The Cassandra community is on a mission to deliver a 4.0 GA release that is ready to be deployed to production. You can guarantee this holds true by running your application workloads against the Beta release and contributing to the community's validation effort to get Cassandra 4.0 to GA.

With over 1,000 bug fixes, improvements and new features and the project's wholehearted [focus on quality](https://cassandra.apache.org/blog/2018/08/21/testing_apache_cassandra.html) with [replay, fuzz, property-based, fault-injection](https://cassandra.apache.org/blog/2018/10/17/finding_bugs_with_property_based_testing.html), and performance tests on clusters as large as 1,000 nodes and with hundreds of real world use cases and schemas tested, Cassandra 4.0 redefines what users should expect from any open or closed source database. With software, hardware, and QA testing donations from the likes of Instaclustr, iland, Amazon, and Datastax, this release has seen an unprecedented cross-industry collaboration towards releasing a battle-tested database with enterprise security features and an understanding of what it takes to deliver scale in the cloud.

There will be no new features or breaking API changes in future Beta or GA builds. You can expect the time you put into the beta to translate into transitioning your production workloads to 4.0 in the near future.

Quality in distributed infrastructure software takes time and this release is no exception. Open source projects are only as strong as the community of people that build and use them, so your feedback is a critical part of making this the best release in project history; share your thoughts on the [user or dev mailing lists](https://cassandra.apache.org/community/) or in the [#cassandra ASF slack channel](https://cassandra.apache.org/community/). 


#### **Redefining the elasticity you should expect from your distributed systems with Zero Copy Streaming**

**5x faster scaling operations**

Cassandra streams data between nodes during scaling operations such as adding a new node or datacenter during peak traffic times. Thanks to the new Zero Copy Streaming functionality in 4.0, this critical operation is now up to [5x faster](https://cassandra.apache.org/blog/2019/04/09/benchmarking_streaming.html) without vnodes compared to previous versions, which means a more elastic architecture particularly in cloud and Kubernetes environments. 

Globally distributed systems have unique consistency caveats and Cassandra keeps the data replicas in sync through a process called repair. Many of the fundamentals of the algorithm for incremental repair were rewritten to harden and [optimize incremental repair](https://thelastpickle.com/blog/2018/09/10/incremental-repair-improvements-in-cassandra-4.html) for a faster and less resource intensive operation to maintain consistency across data replicas. 


#### **Giving you visibility and control over what's happening in your cluster with real time Audit Logging and Traffic Replay**

**Enterprise-grade security & observability**

To ensure regulatory and security compliance with SOX, PCI or GDPR, it's critical to understand who is accessing data and when they are accessing it. Cassandra 4.0 delivers a long awaited [audit logging feature](https://cassandra.apache.org/blog/2018/10/29/audit_logging_cassandra.html) for operators to track the DML, DDL, and DCL activity with minimal impact to normal workload performance. Built on the same underlying implementation, there is also a new [fqltool](https://cassandra.apache.org/doc/latest/new/fqllogging.html) that allows the capture and replay of production workloads for analysis. 

There are [new controls](https://thelastpickle.com/blog/2018/05/08/cassandra-4.0-datacentre-security-improvements.html) to enable use cases that require data access on a per data center basis. For example, if you have a data center in the United States and a data center in Europe, you can now configure a Cassandra role to only have access to a single data center using the new CassandraNetworkAuthorizer. 

For years, the primary way to observe Cassandra clusters has been through JMX and open source tools such as Instaclustr's [Cassandra Exporter](https://github.com/instaclustr/cassandra-exporter) and DataStax's [Metrics Collector](https://github.com/datastax/metric-collector-for-apache-cassandra). In this most recent version of Cassandra you can selectively expose system metrics or configuration settings via [Virtual Tables](https://thelastpickle.com/blog/2019/03/08/virtual-tables-in-cassandra-4_0.html) that are consumed like any other Cassandra table. This delivers flexibility for operators to ensure that they have the signals in place to keep their deployments healthy. 


#### **Looking to the future with Java 11 support and ZGC**

One of the most exciting features of Java 11 is the new [Z Garbage Collector (ZGC)](https://thelastpickle.com/blog/2018/08/16/java11.html) that aims to reduce GC pause times to a max of a few milliseconds with no latency degradation as heap sizes increase. This feature is still experimental and thorough testing should be performed before deploying to production. These improvements significantly improve the node availability profiles from garbage collection on a cluster which is why this feature has been included as experimental in the Cassandra 4.0 release. 


#### **Part of a vibrant and healthy ecosystem**

The third-party ecosystem has their eyes on this release and a number of utilities have already added support for Cassandra 4.0. These include the client driver libraries, Spring Boot and Spring Data, Quarkus, the DataStax Kafka Connector and Bulk Loader, The Last Pickle's Cassandra Reaper tool for managing repairs, Medusa for handling backup and restore, the Spark Cassandra Connector, The Definitive Guide for Apache Cassandra, and the list goes on. 

**Get started today**

There's no doubt that open source drives innovation and the Cassandra 4.0 Beta exemplifies the value in a community of contributors that run Cassandra in some of the largest deployments in the world. 

To put it in perspective, if you use a website or a smartphone today, you're probably touching a Cassandra-backed system.

To download the Beta, head to the [Apache Cassandra downloads site](https://cassandra.apache.org/download/). 

**Resources:**

Apache Cassandra Blog: [Even Higher Availability with 5x Faster Streaming in Cassandra 4.0](https://cassandra.apache.org/blog/2019/04/09/benchmarking_streaming.html)

The Last Pickle Blog: [Incremental Repair Improvements in Cassandra 4](https://thelastpickle.com/blog/2018/09/10/incremental-repair-improvements-in-cassandra-4.html)

Apache Cassandra Blog: [Audit Logging in Apache Cassandra 4.0](https://cassandra.apache.org/blog/2018/10/29/audit_logging_cassandra.html)

The Last Pickle Blog: [Cassandra 4.0 Data Center Security Enhancements](https://thelastpickle.com/blog/2018/05/08/cassandra-4.0-datacentre-security-improvements.html)

The Last Pickle Blog: [Virtual tables are coming in Cassandra 4.0](https://thelastpickle.com/blog/2019/03/08/virtual-tables-in-cassandra-4_0.html)

The Last Pickle Blog: [Java 11 Support in Apache Cassandra 4.0](https://thelastpickle.com/blog/2018/08/16/java11.html)



![Apache Cassandra Infographic](/img/blog-post-apache-cassandra-4-0-beta1/apache-cassandra-infographic-final.jpg "Apache Cassandra Infographic")
