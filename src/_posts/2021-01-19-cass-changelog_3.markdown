---
layout: post
title: "Apache Cassandra Changelog #3 | January 2021"
date:   2021-01-19
author: the Apache Cassandra Community
categories: blog
---
Our monthly roundup of key activities and knowledge to keep the community informed.

![Apache Cassandra Changelog Header](/img/changelog_header.jpg "image_tooltip")

## Release Notes

#### **Released**
Apache Cassandra [4.0-beta4](https://www.apache.org/dyn/closer.lua/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz) ([pgp](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.asc), [sha256](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.sha256) and [sha512](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.sha512)) was released on December 30. Please pay attention to [release notes](https://gitbox.apache.org/repos/asf?p=cassandra.git;a=blob_plain;f=CHANGES.txt;hb=refs/tags/cassandra-4.0-beta4) and let the community know if you encounter problems. Join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay updated.

#### **Changed**
The current status of Cassandra 4.0 GA can be viewed on this [Jira board](https://issues.apache.org/jira/secure/RapidBoard.jspa?rapidView=355&quickFilter=1661) (ASF login required). RC is imminent with testing underway. Read the latest summary from the community [here](https://lists.apache.org/thread.html/r0caf3bc4c3d5b2ef2a9cc299b65a13ce55fa925ceeb404c986809839%40%3Cdev.cassandra.apache.org%3E). 

## Community Notes

_Updates on Cassandra Enhancement Proposals (CEPs), how to contribute, and other community activities._

#### **Added**
The Cassandra community welcomed one new PMC member and five new committers in 2020! Congratulations to **Mick Semb Wever** who joined the PMC and **Jordan West**, **David Capwell**, **Zhao Yang**, **Ekaterina Dimitrova**, and **Yifan Cai** who accepted invitations to become Cassandra committers! 

#### **Changed**
The Kubernetes SIG is discussing how to extend the group’s scope beyond the operator, as well as sharing an update on current operator merge efforts in the latest meeting. [Watch here](https://www.youtube.com/watch?v=3X0Ulor3THU&feature=youtu.be).

[![IApache Cassandra Kubernetes SIG Meeting Header](https://i.ytimg.com/vi/3X0Ulor3THU/sddefault.jpg)](https://www.youtube.com/watch?v=3X0Ulor3THU&t=135s)

## User Space

#### **Keen.io**
Under the covers, Keen leverages Kafka, Apache Cassandra NoSQL database and the Apache Spark analytics engine, adding a RESTful API and a number of SDKs for different languages. Keen enriches streaming data with relevant metadata and enables customers to stream enriched data to Amazon S3 or any other data store. - [Keen.io](https://siliconangle.com/2020/10/09/data-firehose-next-generation-streaming-technologies-goes-cloud-native/)

#### **Monzo**
Suhail Patel explains how Monzo prepared for the recent crowdfunding (run entirely through its app, using the very same platform that runs the bank) which saw more than 9,000 people investing in the first five minutes. He covers Monzo's microservice architecture (on Go and Kubernetes) and how they profiled and optimized key platform components such as Cassandra and Linkerd. - [Suhil Patel](https://www.infoq.com/presentations/monzo-microservices-arch/?utm_source=presentations&utm_medium=london&utm_campaign=qcon)

## In the News

**ZDNet -** [Meet Stargate, DataStax's GraphQL for databases. First stop - Cassandra](https://www.zdnet.com/article/meet-stargate-datastaxs-graphql-for-databases-first-stop-cassandra/)

**CIO -** [It’s a good day to corral data sprawl](https://www.cio.com/article/3601191/its-a-good-day-to-corral-data-sprawl.html)

**TechTarget -** [Stargate API brings GraphQL to Cassandra database](https://searchdatamanagement.techtarget.com/news/252493551/Stargate-API-brings-GraphQL-to-Cassandra-Database)

**ODBMS -** [On the Cassandra 4.0 beta release. Q&A with Ekaterina Dimitrova, Apache Cassandra Contributor](http://www.odbms.org/2020/12/on-the-cassandra-4-0-beta-release-qa-with-ekaterina-dimitrova-apache-cassandra-contributor/)

## Cassandra Tutorials & More

[Intro to Apache Cassandra for Data Engineers](https://www.confessionsofadataguy.com/intro-to-apache-cassandra-for-data-engineers/) - Daniel Beach, Confessions of a Data Guy

[Impacts of many columns in a Cassandra table](https://thelastpickle.com/blog/2020/12/17/impacts-of-many-columns-in-cassandra-table.html) - Alex Dejanovski, The Last Pickle

[Migrating Cassandra from one Kubernetes cluster to another without data loss](https://medium.com/flant-com/migrating-cassandra-between-kubernetes-clusters-ae4ab4ada028) - Flant staff

[Real-time Stream Analytics and User Scoring Using Apache Druid, Flink & Cassandra at Deep.BI](https://www.deep.bi/blog/real-time-stream-analytics-and-user-scoring-using-apache-flink-druid-cassandra-at-deep-bi) - Hisham Itani, Deep.BI

User thread: [Network Bandwidth and Multi-DC replication](https://lists.apache.org/thread.html/rb92c715974408a19961733d6b744c36e100280259b1c6ecbc607c5fd%40%3Cuser.cassandra.apache.org%3E) (Login required)

![Apache Cassandra Changelog Footer](/img/changelog_footer.jpg "image_tooltip")

---


Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io). 
