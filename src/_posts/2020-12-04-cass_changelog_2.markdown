---
layout: post
title: "Apache Cassandra Changelog #2 | December 2020"
date:   2020-12-01
author: the Apache Cassandra Community
categories: blog
---
Our monthly roundup of key activities and knowledge to keep the community informed.

![Apache Cassandra Changelog Header](/img/changelog_header.jpg "image_tooltip")

## Release Notes

#### **Released**
Apache #Cassandra 4.0-beta3, 3.11.9, 3.0.23, and 2.2.19 were released on November 4 and are [in the repositories](https://cassandra.apache.org/download/). Please pay attention to release notes and let the community know if you encounter problems. Join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay updated.

#### **Changed**
Cassandra 4.0 is progressing toward GA. There are 1,390 total tickets and remaining tickets represent 5.5% of total scope. Read the [full summary](https://lists.apache.org/thread.html/r9c6cc19f67d3259e64abbe2b960b8914476d9bfa2463d57c6d5cc44b%40%3Cdev.cassandra.apache.org%3E) shared to the dev mailing list and take a look at the [open tickets](https://issues.apache.org/jira/secure/RapidBoard.jspa?rapidView=355&quickFilter=1661&quickFilter=1658) that need reviewers.

Cassandra 4.0 will be dropping support for older distributions of CentOS 5, Debian 4, and Ubuntu 7.10. [Learn more](https://lists.apache.org/thread.html/r513c507ef19a8524ad5389e548f3d5bbfeb9e7747f3ae4c57ec27329%40%3Cdev.cassandra.apache.org%3E).

## Community Notes

_Updates on Cassandra Enhancement Proposals (CEPs), how to contribute, and other community activities._

#### **Added**
The community weighed options to address reads inconsistencies for Compact Storage as noted in ticket [CASSANDRA-16217](https://issues.apache.org/jira/browse/CASSANDRA-16217) (committed). The conversation continues in ticket [CASSANDRA-16226](https://issues.apache.org/jira/browse/CASSANDRA-16226) with the aim of ensuring there are no huge performance regressions for common queries when you upgrade from 2.x to 3.0 with Compact Storage tables or drop it from a table on 3.0+.

#### **Added**
[CASSANDRA-16222](https://issues.apache.org/jira/browse/CASSANDRA-16222) is a Spark library that can compact and read raw Cassandra SSTables into SparkSQL. By reading the sstables directly from a snapshot directory, one can achieve high performance with minimal impact to a production cluster. It was used to successfully export a 32TB Cassandra table (46bn CQL rows) to HDFS in Parquet format in around 70 minutes, a 20x improvement on previous solutions.

#### **Changed**
Great news for [CEP-2: Kubernetes Operator](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-2+Kubernetes+Operator), the community has agreed to [create a community-based operator](https://lists.apache.org/thread.html/r9e1ff94d7b35cfc663bfa72d4ed3767e963e890f9e1199bfdb96bff0%40%3Cdev.cassandra.apache.org%3E) by merging the cass-operator and CassKop. The work being done can be viewed on GitHub [here](https://github.com/datastax/cass-operator). 

#### **Released**
The Reaper community [announced v2.1](https://thelastpickle.com/blog/2020/10/26/reaper-2_1-released-with-astra-support.html) of its tool that schedules and orchestrates repairs of Apache Cassandra clusters. Read the [docs](http://cassandra-reaper.io/docs/).

#### **Released**
Apache Cassandra 4.0-beta-1 was [released on FreeBSD](https://lists.apache.org/thread.html/r040f39dcc038d607c0cc36731150ce8ecb67d7399304db97e7f8b38b%40%3Cuser.cassandra.apache.org%3E).

## User Space

#### **Netflix**
“With these optimized Cassandra clusters in place, it now costs us 71% less to operate clusters and we could store 35x more data than our previous configuration.” - [Maulik Pandey](https://netflixtechblog.com/building-netflixs-distributed-tracing-infrastructure-bb856c319304)

#### **Yelp**
“Cassandra is a distributed wide-column NoSQL datastore and is used at Yelp for both primary and derived data. Yelp’s infrastructure for Cassandra has been deployed on AWS EC2 and ASG (Autoscaling Group) for a while now. Each Cassandra cluster in production spans multiple AWS regions.” - [Raghavendra D Prabhu](https://engineeringblog.yelp.com/2020/11/orchestrating-cassandra-on-kubernetes-with-operators.html)

## In the News

**DevPro Journal** - [What’s included in the Cassandra 4.0 Release?](https://www.devprojournal.com/technology-trends/open-source/whats-included-in-the-cassandra-4-0-release/)

**JAXenter** - [Moving to cloud-native applications and data with Kubernetes and Apache Cassandra](https://jaxenter.com/cloud-native-cassandra-172909.html)

**DZone** - [Improving Apache Cassandra’s Front Door and Backpressure](https://dzone.com/articles/improving-apache-cassandras-front-door-and-backpre)

**ApacheCon** - [Building Apache Cassandra 4.0: behind the scenes](https://www.youtube.com/watch?v=rjCVqjLRALo)

## Cassandra Tutorials & More

Users in search of a tool for scheduling backups and performing restores with cloud storage support (archiving to AWS S3, GCS, etc) should consider [Cassandra Medusa](https://github.com/thelastpickle/cassandra-medusa/wiki).

[Apache Cassandra Deployment on OpenEBS and Monitoring on Kubera](https://blog.mayadata.io/apache-cassandra-deployment-on-openebs-and-monitoring-on-kubera) - Abhishek Raj, MayaData

[Lucene Based Indexes on Cassandra](https://www.youtube.com/watch?v=Z0NXWmZAB8s) - Rahul Singh, Anant

[How Netflix Manages Version Upgrades of Cassandra at Scale](https://www.youtube.com/watch?v=8QV2Mc-1s64) - Sumanth Pasupuleti, Netflix

[Impacts of many tables in a Cassandra data model](https://thelastpickle.com/blog/2020/11/25/impacts-of-many-tables-on-cassandra.html) - Alex Dejanovski, The Last Pickle

[Cassandra Upgrade in production : Strategies and Best Practices](https://www.youtube.com/watch?v=eTUXQS7RUQw&list=PLU2OcwpQkYCy_awEe5xwlxGTk5UieA37m&index=181) - Laxmikant Upadhyay, American Express

[Apache Cassandra Collections and Tombstones](https://medium.com/@jeromatron/apache-cassandra-collections-and-tombstones-a45315e97cbc) - Jeremy Hanna

[Spark + Cassandra, All You Need to Know: Tips and Optimizations](https://itnext.io/spark-cassandra-all-you-need-to-know-tips-and-optimizations-d3810cc0bd4e) - Javier Ramos, ITNext

[How to install the Apache Cassandra NoSQL database server on Ubuntu 20.04](https://www.techrepublic.com/article/how-to-install-the-apache-cassandra-nosql-database-server-on-ubuntu-20-04/) - Jack Wallen, TechRepublic

[How to deploy Cassandra on Openshift and open it up to remote connections](https://sindhumurugavel.medium.com/how-to-deploy-cassandra-on-openshift-and-open-it-up-to-remote-connections-c7783861b868) - Sindhu Murugavel

![Apache Cassandra Changelog Footer](/img/changelog_footer.jpg "image_tooltip")
---

Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io). 

