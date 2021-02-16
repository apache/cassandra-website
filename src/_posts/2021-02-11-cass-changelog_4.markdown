---
layout: post
title: "Apache Cassandra Changelog #4 | February 2021"
date:   2021-02-11
author: the Apache Cassandra Community
categories: blog
---

Our monthly roundup of key activities and knowledge to keep the community informed.

![Apache Cassandra Changelog Header](https://cassandra.apache.org/img/changelog_header.jpg)

## Release Notes

#### Released

Apache Cassandra [3.0.24](https://www.apache.org/dyn/closer.lua/cassandra/3.0.24/) ([pgp](https://downloads.apache.org/cassandra/3.0.24/apache-cassandra-3.0.24-bin.tar.gz.asc), [sha256](https://downloads.apache.org/cassandra/3.0.24/apache-cassandra-3.0.24-bin.tar.gz.sha256) and [sha512](https://downloads.apache.org/cassandra/3.0.24/apache-cassandra-3.0.24-bin.tar.gz.sha512)). This is a security-related release for the 3.0 series and was released on February 1. Please read the [release notes](https://gitbox.apache.org/repos/asf?p=cassandra.git;a=blob_plain;f=NEWS.txt;hb=refs/tags/cassandra-3.0.24).

Apache Cassandra [3.11.10](https://www.apache.org/dyn/closer.lua/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz) ([pgp](https://downloads.apache.org/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz.asc), [sha256](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.sha256) and [sha512](https://downloads.apache.org/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz.sha512)) was also released on February 1. You will find the [release notes here](https://gitbox.apache.org/repos/asf?p=cassandra.git;a=blob_plain;f=NEWS.txt;hb=refs/tags/cassandra-3.11.10).

Apache Cassandra [4.0-beta4](https://www.apache.org/dyn/closer.lua/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz) ([pgp](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.asc), [sha256](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.sha256) and [sha512](https://downloads.apache.org/cassandra/4.0-beta4/apache-cassandra-4.0-beta4-bin.tar.gz.sha512)) is the newest version which was released on December 30. Please pay attention to the [release notes](https://gitbox.apache.org/repos/asf?p=cassandra.git;a=blob_plain;f=CHANGES.txt;hb=refs/tags/cassandra-4.0-beta4) and let the community know if you encounter problems with any of the currently supported versions. 

Join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay updated.

#### Changed

A vulnerability rated `Important` was found when using the `dc` or `rack` internode_encryption setting. More details of CVE-2020-17516 Apache Cassandra internode encryption enforcement vulnerability are available on this [user thread](https://lists.apache.org/thread.html/r883eccde63637ea18ab5890c09c18e9573f8080bbccaa5ccd1304b8f%40%3Cuser.cassandra.apache.org%3E). 

Note: The mitigation for 3.11.x users requires an update to 3.11.10 not 3.11.24, as originally stated in the CVE. (For anyone who has perfected a flux capacitor, we would like to borrow it.)

The current status of Cassandra 4.0 GA can be viewed on this [Jira board](https://issues.apache.org/jira/secure/RapidBoard.jspa?rapidView=355&quickFilter=1661) (ASF login required). RC is imminent with testing underway. The remaining tickets represent 3.3% of the total scope. Read the latest summary from the community [here](https://lists.apache.org/thread.html/rbc7e4664c0261b0d82baf4b303a7f10977bf138a7419d97d737e0b1a%40%3Cdev.cassandra.apache.org%3E). 

## Community Notes

_Updates on Cassandra Enhancement Proposals (CEPs), how to contribute, and other community activities._

#### Added

Apache Cassandra will be participating in the Google Summer of Code (GSoC) under the ASF umbrella as a mentoring organization. This is a great opportunity to get involved, especially for newcomers to the Cassandra community.

We’re curating a list of JIRA tickets this month, which will be labeled as `gsoc2021`. This will make them visible in the [Jira issue tracker](https://issues.apache.org/jira/browse/SYNAPSE-1125?jql=labels%20%3D%20gsoc2021) for participants to see and connect with mentors. 

If you would like to volunteer to be a mentor for a GSoC project, please tag the respective JIRA ticket with the `mentor` label. Non-committers can volunteer to be a mentor as long as there is a committer as co-mentor. Projects can be mentored by one or more co-mentors. 

Thanks to Paulo Motta for proposing the idea and getting the ticket list going.

#### Added

Apache Zeppelin [0.9.0](http://zeppelin.apache.org/download.html) was released on January 15. Zeppelin is a collaborative data analytics and visualization tool for distributed, general-purpose data processing system, which supports Apache Cassandra and others. The release notes for the Cassandra CQL Interpreter are available [here](http://zeppelin.apache.org/docs/0.9.0/interpreter/cassandra.html).

#### Changed

For the GA of Apache Cassandra 4.0, any claim of support for Python 2 will be dropped from update documentation. We will also introduce a warning when running in Python 2.7. Support for Python 3 will be backported to at least 3.11, due to existing tickets, but we will undertake the work needed to make packaging and internal tooling support Python 3.

#### Changed

The Kubernetes SIG is discussing how to encourage more participation and to structure SIG meetings around updates on Kubernetes and Cassandra. We also intend to invite other projects (like OpenEDS, Prometheus, and others) to discuss how we can make Cassandra and Kubernetes better. As well as updates, the group discussed handling large-scale backups inside Kubernetes and using S3 APIs to store images. [Watch here](https://www.youtube.com/watch?v=X5mEgFquIoo).

[![kubernetes-sig-meeting-2021-01-14](http://img.youtube.com/vi/X5mEgFquIoo/0.jpg)](http://www.youtube.com/watch?v=X5mEgFquIoo)

## User Space

#### Backblaze

“Backblaze uses Apache Cassandra, a high-performance, scalable distributed database to help manage hundreds of petabytes of data.” - [Andy Klein](https://www.backblaze.com/blog/wide-partitions-in-apache-cassandra-3-11/)

#### Witfoo

Witfoo uses Cassandra for big data needs in cybersecurity operations. In response to the recent licensing changes at Elastic, Witfoo decided to blog about its journey away from Elastic to Apache Cassandra in 2019. - [Witfoo.com](https://www.witfoo.com/blog/our-move-from-elastic-to-cassandra/)

_Do you have a Cassandra case study to share? Email [cassandra@constantia.io](mailto:cassandra@constantia.io)._

## In the News

The New Stack: [What Is Data Management in the Kubernetes Age?](https://thenewstack.io/what-is-data-management-in-the-kubernetes-age/)

eWeek: [Top Vendors of Database Management Software for 2021](https://www.eweek.com/database/top-vendors-of-database-management-software-for-2021)

Software Testing Tips and Tricks: [Top 10 Big Data Tools (Big Data Analytics Tools) in 2021](https://www.softwaretesttips.com/big-data-tools/)

InfoQ: [K8ssandra: Production-Ready Platform for Running Apache Cassandra on Kubernetes](https://www.infoq.com/news/2021/01/k8ssandra-cassandra-kubernetes/)

## Cassandra Tutorials & More

[Creating Flamegraphs with Apache Cassandra in Kubernetes (cass-operator)](https://thelastpickle.com/blog/2021/01/31/cassandra_and_kubernetes_cass_operator.html) - Mick Semb Wever, The Last Pickle

[Apache Cassandra : The Interplanetary Database](https://blog.anant.us/apache-cassandra-the-interplanetary-database/) - Rahul Singh, Anant

[How to Install Apache Cassandra on Ubuntu 20.04](https://www.rosehosting.com/blog/how-to-install-apache-cassandra-on-ubuntu-20-04/) - Jeff Wilson, RoseHosting

[The Impacts of Changing the Number of VNodes in Apache Cassandra](https://thelastpickle.com/blog/2021/01/29/impacts-of-changing-the-number-of-vnodes.html) - Anthony Grasso, The Last Pickle

[CASSANDRA 4.0 TESTING](https://www.witfoo.com/blog/cassandra-4-0-testing/) - Charles Herring, Witfoo


![Apache Cassandra Changelog Footer](https://cassandra.apache.org/img/changelog_footer.jpg)

---
Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io). 
