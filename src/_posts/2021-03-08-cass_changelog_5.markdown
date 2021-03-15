---
layout: post
title: "Apache Cassandra Changelog #5 | March 2021"
date:   2021-03-08
author: the Apache Cassandra Community
categories: blog
---

Our monthly roundup of key activities and knowledge to keep the community informed.

![Apache Cassandra Changelog Header](https://cassandra.apache.org/img/changelog_header.jpg)

## Release Notes

#### Released

We are expecting 4.0rc to be released soon, so join the Cassandra [mailing list](https://cassandra.apache.org/community/) to stay up-to-date.

For the latest status on Cassandra 4.0 GA please check the [Jira board](https://issues.apache.org/jira/secure/RapidBoard.jspa?rapidView=355&quickFilter=1661) (ASF login required). We are within line-of-sight to closing out beta scope, with the remaining tickets representing 2.6% of the total scope. Read the latest summary from the community [here](https://lists.apache.org/thread.html/r353a9256a0cb27cffcaaf3e58df0a3bea3bd7373cc490f6646632d37%40%3Cdev.cassandra.apache.org%3E). 

#### Proposed

The community has been discussing [release cadence](https://lists.apache.org/thread.html/re15543b55e5d01245ad75f7ec35af97e9895d37c01562eab31963dd4%40%3Cdev.cassandra.apache.org%3E) after 4.0 reaches GA. An official vote has not been taken on this yet, but the current consensus is one major release every year. Also under discussion are bleeding-edge snapshots (where stability is not guaranteed) and the duration of support for releases.

## Community Notes

_Updates on Cassandra Enhancement Proposals (CEPs), how to contribute, and other community activities._

#### Added

We are pleased to announce that Paulo Motta has accepted the invitation to become a PMC member! This invite comes in recognition of all his contributions to the Apache Cassandra project over many years.

#### Added

Apache Cassandra is taking part in the Google Summer of Code (GSoC) under the ASF umbrella as a mentoring organization. We will be posting a separate blog soon detailing how post-secondary students can get involved.

#### Proposed

With 4.0 approaching completion, the idea of a project roadmap is also being [discussed](https://lists.apache.org/thread.html/r630675e184a3d8db66893c8206ea0bcb9adce62e97dfcb667e4e3438%40%3Cdev.cassandra.apache.org%3E).

#### Changed

The Kubernetes SIG is looking at ways to invite more participants by hosting two meetings to accommodate people in different time zones. [Watch here](https://www.youtube.com/watch?v=rp-0JaptJ3Y).

[![Cassandra Kubernetes SIG Meeting 2021-02-11](http://img.youtube.com/vi/rp-0JaptJ3Y/0.jpg)](http://www.youtube.com/watch?v=rp-0JaptJ3Y)

A community website dedicated to [cass-operator](https://github.com/datastax/cass-operator) is also in development focused on documentation for the operator. Going forward, the Kubernetes SIG is discussing release cadence and looking at six releases a year.

K8ssandra 1.0, an open source production-ready platform for running Apache Cassandra on Kubernetes, was also released on 25 February and announced on its new [community website](https://k8ssandra.io/). Read the [community blog](https://k8ssandra.io/blog/2021/02/26/k8ssandra-1.0-stable-release-and-whats-next/) to find out more and what's next. K8ssandra now has images for Cassandra 3.11.10 and 4.0-beta4 that run rootless containers with Reaper and Medusa functions.

## User Space

#### Instana

“The Instana components are already containerized and run in our SaaS platform, but we still needed to create containers for our databases, Clickhouse, Cassandra, etc., and set up the release pipeline for them. Most of the complexity is not in creating a container with the database running, but in the management of the configuration and how to pass it down in a maintainable way to the corresponding component.” - [Instana](https://hackernoon.com/what-we-learned-by-dockerizing-our-applications-jk1y3xrx)

#### Flant

“We were able to successfully migrate the Cassandra database deployed in Kubernetes to another cluster while keeping the Cassandra production installation in a fully functioning state and without interfering with the operation of applications.” - [Flant](https://medium.com/flant-com/migrating-cassandra-between-kubernetes-clusters-ae4ab4ada028)

_Do you have a Cassandra case study to share? Email [cassandra@constantia.io](mailto:cassandra@constantia.io)._

## In the News

CRN: [Top 10 Highest IT Salaries Based On Tech Skills In 2021: Dice](https://www.crn.com/slide-shows/running-your-business/top-10-highest-it-salaries-based-on-tech-skills-in-2021-dice/3)

TechTarget: [Microsoft ignites Apache Cassandra Azure service](https://searchdatamanagement.techtarget.com/news/252497188/Microsoft-ignites-Apache-Cassandra-Azure-service)

Dynamic Business: [5 Ways your Business Could Benefit from Open Source Technology](https://dynamicbusiness.com.au/topics/news/business-open-source-technology-advice-opinion.html)

TWB: [Top 3 Technologies which are winning the Run in 2021](https://www.theworldbeast.com/top-3-technologies-trends-in-2021.html)

## Cassandra Tutorials & More

[Data Operations Guide for Apache Cassandra](https://blog.anant.us/data-operations-guide-for-apache-cassandra/?utm_source=Anant+Corporation+Newsletter&utm_campaign=e7c05585a6-EMAIL_CAMPAIGN_2019_02_04_05_17_COPY_01&utm_medium=email&utm_term=0_d05aef7418-e7c05585a6-500434574&mc_cid=e7c05585a6&mc_eid=ddff654f2f) - Rahul Singh, Anant

[Introduction to Apache Cassandra: What is Apache Cassandra](https://www.ksolves.com/blog/apache-cassandra/introduction-to-apache-cassandra-what-is-apache-cassandra) - Ksolves

[What’s New in Apache Cassandra 4.0](https://www.techwell.com/techwell-insights/2020/03/what-s-new-apache-cassandra-40) - Deepak Vohra, Techwell

[Reaper 2.2 for Apache Cassandra was released](https://thelastpickle.com/blog/2021/02/22/reaper-for-apache-cassandra-2-2-release.html) - Alex Dejanovski, The Last Pickle

[What's new in Apache Zeppelin's Cassandra interpreter](https://alexott.blogspot.com/2020/07/new-functionality-of-cassandra.html) - Alex Ott

![Apache Cassandra Changelog Footer](https://cassandra.apache.org/img/changelog_footer.jpg)

---
Cassandra Changelog is curated by the community. Please send submissions to [cassandra@constantia.io](mailto:cassandra@constantia.io).
