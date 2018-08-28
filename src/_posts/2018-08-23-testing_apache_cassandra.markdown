---
layout: post
title: "Testing Apache Cassandra 4.0"
date:   2018-08-20 20:00:00 -0700
author: the Apache Cassandra Community
categories: blog
---

With the goal of ensuring reliability and stability in Apache Cassandra 4.0, the project's committers have voted to freeze new features on September 1 to concentrate on testing and validation before cutting a stable beta. Towards that goal, the community is investing in methodologies that can be performed at scale to exercise edge cases in the largest Cassandra clusters. The result, we hope, is to make Apache Cassandra 4.0 the best-tested and most reliable major release right out of the gate.

In the interests of communication (and hopefully more participation), here’s a look at some of the approaches being used to test Apache Cassandra 4.0:

---

#### Replay Testing
##### Workload Recording, Log Replay, and Comparison

Replay testing allows for side-by-side comparison of a workload using two versions of the same database. It is a black-box technique that answers the question, “did anything change that we didn’t expect?”

Replay testing is simple in concept: record a workload, then re-issue it against two clusters – one running a stable release and the second running a candidate build. Replay testing a stateful distributed system is more challenging. For a subset of workloads, we can achieve determinism in testing by grouping writes by CQL partition and ordering them via client-supplied timestamps. This also allows us to achieve parallelism, as recorded workloads can be distributed by partition across an arbitrarily-large fleet of writers. Though linearizing updates within a partition and comparing differences does not allow for validation of all possible workloads (e.g., CAS queries), this subset is very useful.

The suite of Full Query Logging (“FQL”) tools in Apache Cassandra enable workload recording. [CASSANDRA-14618](https://issues.apache.org/jira/browse/CASSANDRA-14618) and [CASSANDRA-14619](https://issues.apache.org/jira/browse/CASSANDRA-14619) will add fqltool replay and fqltool compare, enabling log replay and comparison. Standard tools in the Apache ecosystem such as [Apache Spark](https://spark.apache.org) and [Apache Mesos](https://mesos.apache.org) can also make parallelizing replay and comparison across large clusters of machines straightforward.


---

#### Fuzz Testing and Property-Based Testing
##### Dynamic Test Generation and Fuzzing

Fuzz testing dynamically generates input to be passed through a function for validation. We can make fuzz testing smarter in stateful systems like Apache Cassandra to assert that persisted data conforms to the database’s contracts: acknowledged writes are not lost, deleted data is not resurrected, and consistency levels are respected. Fuzz testing of storage systems to validate these properties requires maintaining a record of responses received from the system; the development of a model representing valid legal states of data within the database; and a validation pass to assert that responses reflect valid states according to that model.

Property-based testing combines fuzz testing and assertions to explore a state space using randomly-generated input. These tests provide dynamic input to the system and assert that its fundamental properties are not violated. These properties can range from generic (e.g., “I can write data and read it back”) to specific (“range tombstone bounds synthesized during short-read-protection reads are properly closed”); and from local to distributed (e.g., “replacing every single node in a cluster results in an identical database”). To simplify debugging, property-based testing libraries like [QuickTheories](https://github.com/ncredinburgh/QuickTheories) also provide a “shrinker,” which attempts to generate the simplest possible failing case after detecting input or a sequence of actions that triggers a failure.

Unlike model checkers, property-based tests don’t exhaust the state space – but explore it until a threshold of examples is reached. This allows for the computation to be distributed across many machines to gain confidence in code and infrastructure that scales with the amount of computation applied to test it.

---

#### Distributed Tests and Fault-Injection Testing
##### Validating Behavior Under Fault Scenarios

All of the above techniques can be combined with fault injection testing to validate that the system maintains availability where expected in fault scenarios, that fundamental properties hold, and that reads and writes conform to the system’s contracts. By asserting series of invariants under fault scenarios using different techniques, we gain the ability to exercise edge cases in the system that may reveal unexpected failures in extreme scenarios. Injected faults can take many forms – network partitions, process pauses, disk failures, and more.

---

#### Upgrade Testing
##### Ensuring a Safe Upgrade Path

Finally, it's not enough to test one version of the database. Upgrade testing allows us to validate the upgrade path between major versions, ensuring that a rolling upgrade can be completed successfully, and that contents of the resulting upgraded database is identical to the original. To perform upgrade tests, we begin by snapshotting a cluster and cloning it twice, resulting in two identical clusters. One of the clusters is then upgraded. Finally, we perform a row-by-row scan and comparison of all data in each partition to assert that all rows read are identical, logging any deltas for investigation. Like fault injection tests, upgrade tests can also be thought of as an operational scenario all other types of tests can be parameterized against.

---

#### Wrapping Up

The Apache Cassandra developer community is working hard to deliver Cassandra 4.0 as the most stable major release to date, bringing a variety of methodologies to bear on the problem. We invite you to join us in the effort, deploying these techniques within your infrastructure and testing the release on your workloads. Learn more about how to get involved [here](http://cassandra.apache.org/community/).

The more that join, the better the release we’ll ship together.
