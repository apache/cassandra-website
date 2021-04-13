---
layout: post
title: "Apache Cassandra Changelog #6"
date:   2020-04-13 x
author: the Apache Cassandra Community
categories: blog
---

![Apache Cassandra Changelog Header](https://cassandra.apache.org/img/changelog_header.jpg)

Our monthly roundup of key activities and knowledge to keep the community informed.

## **Release Notes**

#### **Released**

A [blocking issue](https://lists.apache.org/thread.html/re60773108292390b8ec754bd73bcddc95ae9abd3f5c9ab4981ef6b2c%40%3Cdev.cassandra.apache.org%3E) was found in beta-2 which has delayed the release of rc-1. Also during rc-1 evaluation, [some concerns were raised](https://lists.apache.org/thread.html/r3057bdd64b46bef1561b5fef3a7c1e40ade0da80df9915201cc8f315%40%3Cdev.cassandra.apache.org%3E) about the contents of the source distribution, but work to resolve that got underway quickly and is ready to commit.

For the latest status on Cassandra 4.0 GA, please check the [Jira board](https://issues.apache.org/jira/secure/RapidBoard.jspa?rapidView=355&quickFilter=1661) (ASF login required). However, we expect GA to arrive very soon! Read the latest summary from the community [here](https://lists.apache.org/thread.html/rcf883cc5c1fe87b80106e74092c9ed79127e5071883f194bc204b09a%40%3Cdev.cassandra.apache.org%3E). The remaining tickets represent 1% of the total scope.

Join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay up-to-date.
 
#### **Changed**
The release cadence for the Apache Cassandra project is changing. The community has agreed to one release every year, plus periodic trunk snapshots. The number of releases that will be supported in this agreement is three, and every incoming release will be [supported for three years](https://lists.apache.org/thread.html/re15543b55e5d01245ad75f7ec35af97e9895d37c01562eab31963dd4%40%3Cdev.cassandra.apache.org%3E).

## **Community Notes**

_Updates on Cassandra Enhancement Proposals (CEPs), how to contribute, and other community activities._

#### **Added**
The [PMC is pleased to announce](https://lists.apache.org/thread.html/r1e545f41faf6c4ac0a4c196f9ae85a142abd89d8c61320ad44e303a0%40%3Cdev.cassandra.apache.org%3E) that Berenguer Blasi has accepted the invitation to become a project committer. Thanks so much, Berenguer, for all the work you have done!

#### **Added**
As the community gets closer to the launch of 4.0, we are organizing a celebration with the help of ASF -- [Cassandra World Party 4.0](https://cassandra.apache.org/blog/2021/03/25/world_party.html) will be a one-day, no-cost virtual event on Wednesday, April 28 to bring the global community together in celebration of the upcoming release milestone. The [CFP for 5-minute lightning talks](https://sessionize.com/cassandra) is open now until April 9 -- newcomers welcome! [Register here](https://hopin.com/events/apache-cassandra-4-0-world-party).

#### **Added**
Apache Cassandra is taking part in the [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) under the ASF umbrella as a mentoring organization. If you’re a post-secondary student and looking for an exciting opportunity to contribute to the project that powers your favorite Internet services then read [Paulo Motta’s GSoC blog post for the details](https://cassandra.apache.org/blog/2021/03/10/join_cassandra_gsoc_2021.html).

#### **Changed**
Recent updates to [cass-operator](https://github.com/datastax/cass-operator) in March by the Kubernetes SIG have seen the specification for seeds now supporting hostnames and separate seeds for separate data centers. Currently, the SIG is discussing whether cass-operator, the community-developed operator for Apache Cassandra, should have CRDs for keyspaces and roles, how to accomplish pod-specific configurations, and whether CRDs should represent Schema, [watch here](https://www.youtube.com/watch?v=82o_tr9UPgQ).

The project is also looking at how to make the cass-operator multi-cluster by using the same approach used for Multi-CassKop. One idea is to use existing [CassKop](https://github.com/Orange-OpenSource/casskop) CRDs to manage cass-operator, and it could be a way to demonstrate how easy it is to migrate from one operator to another.

[K8ssandra](https://k8ssandra.io/) will be seeking to support Apache Cassandra 4.0 features, which involve some new configuration settings and require changes in the config builder. It will also be supporting JDK 11, the new garbage collectors, and the auditing features.

[![kubernetes-sig-meeting-2021-03-25](http://img.youtube.com/vi/82o_tr9UPgQ/0.jpg)](https://www.youtube.com/watch?v=82o_tr9UPgQ) 

## **User Space**

#### **American Express**
During last year’s ApacheCon, Laxmikant Upadhyay presented a 35-minute guide on the best practices and strategies for upgrading Apache Cassandra in production. This includes pre- and post-upgrade steps and rolling and parallel upgrade strategies for Cassandra clusters. - [Laxmikant Upadhyay](https://www.youtube.com/watch?v=eTUXQS7RUQw&list=PLU2OcwpQkYCy_awEe5xwlxGTk5UieA37m&index=182)

#### **Spotify**
In a recent AMA, Spotify discussed Backstage, its open platform for building developer portals. Spotify elaborated on the database solutions it provides internally: “Spotify is mostly on GCP so our devs use a mix of Google-managed storage products and self-managed ones.[...] The unmanaged storage solutions Spotify devs start and operate themselves on GCE include Apache Cassandra, PostgreSQL, Memcached, Elastic Search, and Redis. We hope to support stateful workloads in the future. We've explored using PersistentVolumes backed by persistent disks.” - [David Xia](https://www.reddit.com/r/kubernetes/comments/lwb31v/were_the_engineers_rethinking_kubernetes_at/)

_Do you have a Cassandra case study to share? Email [cassandra@constantia.io](mailto:cassandra@constantia.io)._ 

## **In the News**

TFiR: [How Apache Cassandra Works With Containers](https://www.tfir.io/how-apache-cassandra-works-with-containers/)

Dataversity: [Why 2021 Will Be a Big Year for Apache Cassandra (and Its Users)](https://www.dataversity.net/why-2021-will-be-a-big-year-for-apache-cassandra-and-its-users/)

ZDNet: [Microsoft Ignite Data and Analytics Roundup: Platform Extensions Are the Key Theme](https://www.zdnet.com/article/microsoft-ignite-data-and-analytics-roundup-platform-extensions-are-the-key-theme/)

Techcrunch: [Microsoft Azure Expands its NoSQL Portfolio with Managed Instances for Apache Cassandra](https://techcrunch.com/2021/03/02/microsoft-azure-expands-its-nosql-portfolio-with-managed-instances-for-apache-cassandra/)

## **Cassandra Tutorials & More**

[How to Install Apache Cassandra on CentOS 8](https://linuxhint.com/install-apache-cassandra-centos-8/) - Shehroz Azam, LinuxHint
[Cassandra With Java: Introduction to UDT](https://dzone.com/articles/cassandra-udt) - Otavio Santana, DZone
[Apache Cassandra Horizontal Scalability for Java Applications [Book]](https://dzone.com/articles/jcassandra#) - Otavio Santana, DZone
[Cloud-native applications and data with Kubernetes and Apache Cassandra](https://devopscon.io/blog/cloud-native-applications-and-data-with-kubernetes-and-apache-cassandra/) - Patrick McFadin, DataStax

[![Apache Cassandra Changelog Footer](https://cassandra.apache.org/img/changelog_footer.jpg)](https://cassandra.apache.org/community/)

Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io).