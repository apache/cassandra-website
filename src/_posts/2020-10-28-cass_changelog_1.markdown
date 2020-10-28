---
layout: post
title: "Apache Cassandra Changelog #1 (October 2020)"
date:   2020-10-28 
author: the Apache Cassandra Community
categories: blog
---

Introducing the first Cassandra Changelog blog! Our monthly roundup of key activities and knowledge to keep the community informed. 

![Cassandra Changelog header](/img/changelog_header.jpg "image_tooltip")

## Release Notes

#### Updated

The most current Apache Cassandra releases are 4.0-beta2, 3.11.8, 3.0.22, 2.2.18 and 2.1.22 released on August 31 and are [in the repositories](https://cassandra.apache.org/download/). The next cut of releases will be out soon―join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay up-to-date.

We continue to make progress toward the 4.0 GA release with the overarching goal of it being at a state where major users should feel confident running it in production when it is cut. Over 1,300 Jira tickets have been closed and [less than 100 remain](https://issues.apache.org/jira/projects/CASSANDRA/versions/12346094) as of this post. To gain this confidence, there are various ongoing testing efforts involving correctness, performance, and ease of use.

#### Added

With CASSANDRA-15013, the community improved Cassandra&#39;s ability to [handle high throughput workloads](https://cassandra.apache.org/blog/2020/09/03/improving-resiliency.html), while having enough safeguards in place to protect itself from potentially going out of memory.

#### Added

The [Harry project](https://github.com/apache/cassandra-harry/blob/master/README.md) is a fuzz testing tool that aims to generate reproducible workloads that are as close to real-life as possible, while being able to efficiently verify the cluster state against the model without pausing the workload itself.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Check out Harry, a fuzz-testing tool for Apache Cassandra, the best way to test databases or storage engines you&#39;ve ever used: <a href="https://t.co/WjtkIMMrXp">https://t.co/WjtkIMMrXp</a></p>&mdash; αλεx π (@ifesdjeen) <a href="https://twitter.com/ifesdjeen/status/1308036563402719234?ref_src=twsrc%5Etfw">September 21, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

#### Added

The community published its first [Apache Cassandra Usage Report 2020](https://cassandra.apache.org/blog/2020/09/17/cassandra-usage-report-2020.html) detailing findings from a comprehensive global survey of 901 practitioners on Cassandra usage to provide a baseline understanding of who, how, and why organizations use Cassandra.

## Community Notes

_Updates on new and active Cassandra Enhancement Proposals (CEPs) and how to contribute._

#### Changed

[CEP-2: Kubernetes Operator](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-2+Kubernetes+Operator) was introduced this year and is an active discussion on creation of a community-based operator with the goal of making it easy to run Cassandra on Kubernetes.

#### Added

[CEP-7: Storage Attached Index (SAI)](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-7%3A+Storage+Attached+Index) is a new secondary index for Cassandra that builds on the advancements made with SASI. It is intended to replace the existing built-in secondary index implementations.

#### Added

Cassandra was selected by the ASF Diversity &amp; Inclusion committee to be [included in a research project](https://lists.apache.org/thread.html/rfa1673c9f8b42cf286f5fb763eb987eced2bdea1a619358869a49bef%40%3Cdev.cassandra.apache.org%3E) to evaluate and understand the current state of diversity.

## User Space

**Bigmate**

&quot;In vetting MySQL, MongoDB, and other potential databases for IoT scale, we found they couldn&#39;t match the scalability we could get with open source Apache Cassandra. Cassandra&#39;s built-for-scale architecture enables us to handle millions of operations or concurrent users each second with ease – making it ideal for IoT deployments.&quot; - [Brett Orr](https://www.iotcentral.io/blog/how-open-source-apache-cassandra-solved-our-iot-scalability-and-r)

**Bloomberg**

&quot;Our group is working on a multi-year build, creating a new Index Construction Platform to handle the daily production of the Bloomberg Barclays fixed income indices. This involves building and productionizing an Apache Solr-backed search platform to handle thousands of searches per minute, an Apache Cassandra back-end database to store millions of data points per day, and a distributed computational engine to handle millions of computations daily.&quot; - [Noel Gunasekar](https://www.techatbloomberg.com/blog/meet-the-team-indices-engineering/)

## In the News

**Solutions Review** - [The Five Best Apache Cassandra Books on Our Reading List](https://solutionsreview.com/data-management/the-five-best-apache-cassandra-books-on-our-reading-list/)

**ZDNet** - [What Cassandra users think of their NoSQL DBMS](https://www.zdnet.com/article/what-cassandra-users-think-of-their-nosql-dbms/)

**Datanami** - [Cassandra Adoption Correlates with Experience](https://www.datanami.com/2020/09/22/cassandra-adoption-correlates-with-experience/)

**Container Journal -** [5 to 1: An Overview of Apache Cassandra Kubernetes Operators](https://containerjournal.com/topics/container-management/5-to-1-an-overview-of-apache-cassandra-kubernetes-operators/)

**Datanami** - [Cassandra Gets Monitoring, Performance Upgrades](https://www.datanami.com/2020/07/21/cassandra-gets-monitoring-performance-upgrades/)

**ZDNet** - [Faster than ever, Apache Cassandra 4.0 beta is on its way](https://www.zdnet.com/article/faster-than-ever-apache-cassandra-4-0-beta-is-on-its-way/)

## Cassandra Tutorials & More

A Cassandra user was in search of a tool to perform schema DDL upgrades. Another user suggested [https://github.com/patka/cassandra-migration](https://github.com/patka/cassandra-migration) to ensure you don&#39;t get schema mismatches if running multiple upgrade statements in one migration. See the [full email](https://lists.apache.org/thread.html/rdfee145c4c5d920f644c6bcd081c6fb446d52b055c133485217b8143%40%3Cuser.cassandra.apache.org%3E) on the user mailing list for other recommended tools.

[Start using virtual tables in Apache Cassandra 4.0](https://opensource.com/article/20/10/virtual-tables-apache-cassandra) - Ben Bromhead, Instaclustr

[Benchmarking Apache Cassandra with Rust](https://pkolaczk.github.io/benchmarking-cassandra/) - Piotr Kołaczkowski, DataStax

[Open Source BI Tools and Cassandra](https://blog.anant.us/open-source-bi-tools-and-cassandra/) - Arpan Patel, Anant Corporation

[Build Fault Tolerant Applications With Cassandra API for Azure Cosmos DB](https://dzone.com/articles/build-fault-tolerant-applications-with-cassandra-a) - Abhishek Gupta, Microsoft

[Understanding Data Modifications in Cassandra](https://www.red-gate.com/simple-talk/blogs/understanding-data-modifications-in-cassandra/) - Sameer Shukla, Redgate

![Cassandra Changelog footer](/img/changelog_footer.jpg "image_tooltip")

Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io).
