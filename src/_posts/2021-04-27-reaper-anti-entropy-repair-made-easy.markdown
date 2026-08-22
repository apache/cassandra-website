---
layout: post
title: "Reaper - Anti-entropy repair made easy"
date:   2021-04-27
author: the Apache Cassandra Community
categories: blog
excerpt: Reaper is an open source tool written in Java and built with Dropwizard to schedule and orchestrate repairs of Apache Cassandra clusters. It was originally designed and open-sourced by Spotify in an attempt to automate repairs while applying best practices from their solid production experience.
---

# Reaper: Anti-entropy repair made easy

Reaper is an open source tool written in Java and built with Dropwizard to schedule and orchestrate repairs of Apache Cassandra® clusters. It was originally [designed and open-sourced by Spotify](https://www.slideshare.net/planetcassandra/spotify-automating-cassandra-repairs) in an attempt to automate repairs while applying best practices from their solid production experience.


## Repair challenges

Anti-entropy repair is traditionally performed using the nodetool repair command. It can be performed in two ways, full or incremental, and be configured to repair various ranges of tokens: all, primary range or sub-range. Add to this different validation compaction orchestration settings (sequential, parallel and datacenter aware), the fact that anti-compaction may trigger in some cases and you're down a rabbit hole of complexity. All this for an operation that is mandatory and should be simple to run.  

In the 1.x/2.x days of Cassandra (and probably after that), some operators simply gave up on repairing their clusters due to the difficulties in completing the operation successfully, without impacting SLAs.


The main problems that were encountered then during repairs:

* High number of pending compactions and SSTables on disk
* Repairs taking longer than the tombstones GC grace period
* High cluster load due to repair pressure
* Blocked/never-ending repairs
* Repair isn't resumable in case of failure
* vnodes made the operation very long and challenging to perform


## Reaper performs safe repairs

Reaper was built to address those issues and make repairs as safe and reliable as possible. It splits the repair operations into evenly sized subranges and schedules them so that:  

* All nodes are kept busy repairing small units of data if possible
* A single segment is running on a node at once
* Segments lasting too long are terminated and re-scheduled
* Failed segments get replayed in case of transient failure
* Pending compactions will be monitored to pause segment scheduling, preventing overload
* Repairs can be paused

The tool also supports incremental repair which should be safely usable starting with Cassandra 4.0. Since Cassandra 3.0, Reaper can create segments with several token ranges to reduce the overhead of vnodes on repairs. Such ranges will be repaired in a single job by Cassandra as segments will only contain ranges that are replicated on the same set of nodes.


## Reaper features

Reaper ships with a [REST API](http://cassandra-reaper.io/docs/api/), a command line tool (spreaper) and a Web UI:

![Reaper Cluster View](/img/blog-post-reaper/reaper-cluster-view.png)

It collects and displays runtime Cassandra metrics, running compactions and ongoing streaming sessions: 

![Reaper Node Metrics](/img/blog-post-reaper/reaper-node-metrics.png)

It ships with a scheduler for recurring repairs but can also perform on demand one off repairs:

![Reaper Schedules](/img/blog-post-reaper/reaper-schedules.png)

![Reaper Repair](/img/blog-post-reaper/reaper-repair.png)

It's easy to install as [a tarball](http://cassandra-reaper.io/docs/download/install/), a [Docker container](https://hub.docker.com/r/thelastpickle/cassandra-reaper/) or [deb/rpm packages](https://cloudsmith.io/~thelastpickle/repos/reaper/packages/) and can be deployed in various ways to accomodate [your cluster's architecture](http://cassandra-reaper.io/docs/usage/multi_dc_distributed/). A single Reaper instance is capable of managing repairs on dozens of Cassandra clusters but several instances can be deployed to provide high availability or adapt to JMX restrictions in your network: 

![Single Reaper](/img/blog-post-reaper/singlereaper-multidc-all.png)

![Multi Reaper](/img/blog-post-reaper/multireaper-multidc.png)

![HA Reaper](/img/blog-post-reaper/ha-reaper-setup.png)

If JMX is restricted to local access, Reaper can even be deployed as a sidecar:

![Reaper Sidecar](/img/blog-post-reaper/reaper-sidecar.png)

Reaper also has the ability to listen and display live Cassandra’s emitted Diagnostic Events.  

In Cassandra 4.0 internal system “diagnostic events” have become available, via the work done in [CASSANDRA-12944](https://issues.apache.org/jira/browse/CASSANDRA-12944). These allow us to observe internal Cassandra events, for example in unit tests and with external tools. These diagnostic events provide operational monitoring and troubleshooting beyond logs and metrics.  

Reaper can use Postgres and Cassandra itself as a storage backend for its data and is capable of repairing all Cassandra versions since 1.2 up to the latest 4.0.  

In order to make Reaper more efficient, segment orchestration was recently revamped and modernized. It opened for a long awaited feature: fully concurrent repairs for different keyspaces and tables.


You can find more details on these changes in [the 2.2 release blog post](https://thelastpickle.com/blog/2021/02/22/reaper-for-apache-cassandra-2-2-release.html).

## Eager to try Reaper?

Head over to the [cassandra-reaper.io](http://cassandra-reaper.io/) website which contains all information you'll need to get started, install Reaper and stop worrying about repairs!