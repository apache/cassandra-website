---
layout: post
title: "Cassandra and Kubernetes: SIG Update #2"
date:   2021-03-29
author:  Rahul Singh, John Sanda
categories: blog
excerpt: Latest and greatest updates from the Apache Cassandra & Kubernetes Special Interest Group
---

The Cassandra Kubernetes SIG is excited to share that there has been coalescence around the [Cass Operator](https://github.com/datastax/cass-operator) project as the community-based operator.

It is no understatement to say that moving towards a single operator for the Apache Cassandra community has been a technical challenge. There are several [Kubernetes operator projects for Cassandra](https://cassandra.apache.org/blog/2020/08/14/cassandra-and-kubernetes-sig-update.html), and there were at least five different ways to go about this. Initially, it seemed we were going to create a standard and build a fresh operator from scratch, adopting the others’ ideas. For more details on this discussion, check out this lengthy dev mailing list [thread](https://lists.apache.org/thread.html/r473275258f3203121935c2412fbe94c0fc368fe17b72141957afef62%40%3Cdev.cassandra.apache.org%3E). 

For the next stage, the SIG is focused on increasing Cass Operator’s community adoption with the ultimate goal of bringing the project into the ASF.

### Why Cass-Operator?

Several features of the Cass-Operator project, open-sourced by DataStax, made it the prime candidate for the other projects to rally around. (You can read about the five major Kubernetes Operators for Cassandra in the last [Cassandra SIG update](https://cassandra.apache.org/blog/2020/08/14/cassandra-and-kubernetes-sig-update.html).)

![High Level Architecture of the Cass Operator in Kubernetes](/img/blog-post-cassandra-and-kubernetes-sig-update/cass-operator-diagram.png)

Caption: High Level Architecture of the Cass Operator in Kubernetes

Cass-Operator has major features for datacenter provisioning and operations and has Apache Cassandra’s best practices baked into the automations: 

1. **Bootstraps nodes appropriately** - this feature is important because when Cassandra starts up it needs to start the initial seeds first, in each rack, in a uniform manner.
2. **Scales up and scales down clusters gracefully** - nodes are intelligently scaled up and down one at a time across racks so that replicas of data are uniformly distributed.
3. **Automated node recovery processes** - basic operations such as restart, replace node, or replace an instance are all automated.
4. **Basic topology** - this feature makes multi-DC / multi-rack clusters fairly easy to create.
5. **Advanced topology** - Advanced networking at the Kubernetes layer makes multi-region / multi-K8s clusters possible with CNIs such as Cilium or externally via traditional networking tools.
6. **Customizable containers** - applying containerization best practice, this enables human operators to merge containers they have built with what’s offered in the cass-operator so that they don’t have to deal with secrets/volumes.

![An Apache Cassandra Cluster managed by Cass Operator in Kubernetes across different workers with StatefulSets managing the pods running Cassandra.](/img/blog-post-cassandra-and-kubernetes-sig-update/apache-cassandra-cluster-on-kubernetes.png)

Caption: An Apache Cassandra Cluster managed by Cass Operator in Kubernetes across different workers with StatefulSets managing the pods running Cassandra.

### Cass-Operator Differentiators

Cass-Operator has many general features that distinguish it even before it is merged with the powerful features that CassKop will supply: 

1. The operator leverages a number of existing open source tools in the OSS ecosystem and commercial components that have been open-sourced to avoid issues with vendor lock-in:
   1. Open-sourced Cass Config Builder extracted from DataStax OpsCenter Life Cycle Manager.
   2. Open-sourced Management API for Apache Cassandra (MAAC).
   3. Open-sourced Metrics Collector for Apache Cassandra (MCAC).
   4. Open-sourced SRE tools such as Prometheus and Grafana Operator.
2. PodTemplateSpec enables operators to super-customize existing pods. 
3. Cass-Operator implements advanced networking and manages the node ports and host networks.
4. Management API mTLS support provides simple security.
5. Automated generation of keystore and truststore for internode and client to node TLS.
6. Automated superuser account configuration according to best practices
7. NetworkTopologyStrategy is automatically applied with appropriate replication factor (RF) for system keyspaces.
8. Webhook validation ensures that invalid changes are rejected with a helpful message.
9. Rolling cluster updates which allow for changes related to a change in binary (C* upgrade), a change in configuration, and canary deployments - single rack application of changes for validation before broader deployment.
10. Operator certification and thorough testing on several platforms, including Azure AKS, Amazon EKS, Google GKE, Red Hat OpenShift, and VMWare Tanzu Kubernetes.
11. Well documented cloud storage classes, ingress solutions and reference Implementations with an example application using the Java driver. 
12. Super-useful cluster-level stop / resume, which stops all running instances while keeping persistent storage. This feature allows for scaling compute down to zero, and bringing the cluster back up follows the expected Cassandra startup processes. 

### CassKop operator features that are being merged
 
There are features in the CassKop operator, open-sourced by Orange Telecom, which are being merged/committed into the CassOperator project: 

1. Node labeling to map any internal architecture, including network-specific labels to help with multi-datacenter setup.
2. Volumes and sidecar management (which could be linked to PodTemplateSpec).
3. Backup & Restore (Note: the CassKop project ruled out using [Velero](https://velero.io/), and used [Instaclustr esop](https://github.com/instaclustr/esop) but [Medusa](https://github.com/thelastpickle/cassandra-medusa) could work too).
4. Kubectl plugin integration, which is useful on the ops side without an admin UI.
5. MultiCassKop evolution to drive multiple Cass-Operators clusters instead of multiple CassKops clusters (Note: This may remain Orange internal if too specific)

As you can see, there’s a lot of great things being developed for the Apache Cassandra project so that relates well with the Kubernetes world. We’ll also have a roadmap post soon. Join us for the next Cassandra Kubernetes SIG meeting or say hi on the [Apache Software Foundation’s Slack team](https://the-asf.slack.com) by joining the [#cassandra-kubernetes](https://app.slack.com/client/T4S1WH2J3/C014SSUAL9E) channel.

