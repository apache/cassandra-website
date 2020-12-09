---
layout: page
permalink: /third-party/
title: Third-party projects 
is_homepage: false
is_sphinx_doc: false
---

 Third-party projects
---------

### Cassandra as-a-Service cloud offerings

* [Aiven for Apache Cassandra](https://aiven.io/cassandra): Aiven for Apache Cassandra is a fully managed NoSQL database, deployable in the cloud of your choice.
Snap it into your existing workflows with the click of a button, automate away the mundane tasks, and focus on building your core apps. Now running Cassandra 3.11.
* [Amazon Keyspaces (for Apache Cassandra)](https://aws.amazon.com/keyspaces/): Scalable, highly available, and managed Apache Cassandra–compatible database service.
* [DataStax Astra](https://astra.datastax.com): Cloud-native database as-a-service built on Apache Cassandra™ complete with a free-tier and CQL, REST and GraphQL APIs for faster development. Deployable in AWS and GCP.
* [Instaclustr Hosted & Managed Apache Cassandra as a Service](https://www.instaclustr.com/solutions/managed-apache-cassandra): Instaclustr provides a fully managed and SOC 2 certified hosted & managed service for Apache Cassandra® on AWS, Azure, GCP and IBM Cloud.

### Cassandra installation tools
* [Docker community Cassandra images](https://hub.docker.com/_/cassandra): Docker images for Apache Cassandra maintained by the Docker community
* [DataStax Desktop](https://downloads.datastax.com/#desktop): Cross-platform (Windows, MacOSX, Linux) application that allows developers to quickly explore Apache Cassandra™ with a few clicks on their laptop, complete with tutorials and walkthroughs.
* [K8ssandra](https://k8ssandra.io/): K8ssandra provides a production-ready platform for running Apache Cassandra on Kubernetes, including automation for operational tasks such as repairs, backups, and monitoring.
* [The Last Pickle tlp-cluster](https://github.com/thelastpickle/tlp-cluster): tlp-cluster, a tool for launching Cassandra clusters in AWS (DataStax)

### Cassandra tools

* [Adelphi](https://github.com/datastax/adelphi): Authomation tool for testing open-source Cassandra using cassandra-diff, nosqlbench, and fqltool.
* [cassandra.link](https://cassandra.link): Curated site with tools, along with [cassandra.tools](https://cassandra.tools).
* [Cassandra Prometheus Exporter](https://github.com/criteo/cassandra_exporter): Standalone application which exports Cassandra metrics through a prometheus friendly endpoint
* [DataStax Bulk Loader](https://downloads.datastax.com/#bulk-loader): Easy-to-use command line utility for loading and unloading JSON or CSV files to/from the database, counting rows in tables and identifying large partitions. 
* [DataStax Metrics Collector for Cassandra](https://github.com/datastax/metric-collector-for-apache-cassandra): Based on Collectd, aggregates OS and Cassandra metrics along with diagnostic events to facilitate problem resolution and remediation
* [Hackolade](https://hackolade.com/nosqldb.html#cassandra): Visual data modeling tool for Cassandra
* [The Last Pickle Medusa](https://github.com/thelastpickle/cassandra-medusa): Apache Cassandra Backup and Restore Tool (DataStax)
* [The Last Pickle Reaper](https://github.com/thelastpickle/cassandra-reaper): Automated repair tool for Apache Cassandra  (DataStax)
* [The Last Pickle Cassandra stress tool, tlp-stress](https://github.com/thelastpickle/tlp-stress): A workload-centric stress tool for Apache Cassandra. Designed for simplicity, no math degree required. (DataStax)
* [NoSQLBench](https://github.com/nosqlbench/nosqlbench): Pluggable benchmarking suite for Cassandra and other distributed systems
* [Stargate](https://stargate.io): Open source data gateway providing Document, REST, and GraphQL APIs to Apache Cassandra.
* [Instaclustr Esop](https://github.com/instaclustr/esop): Swiss knife for backup and restore of your node to GCP, Azure, S3, Ceph etc. Supports backup and restoration of commit logs too. Esop is embedded in [Instaclustr Icarus](https://github.com/instaclustr/icarus) sidecar so you may backup and restore your cluster remotely and on-the-fly without any disruption.
* [Instaclustr Kerberos plugin](https://github.com/instaclustr/cassandra-kerberos): A GSSAPI authentication provider for Apache Cassandra.
* [Instaclustr Java Driver for Kerberos](https://github.com/instaclustr/cassandra-java-driver-kerberos): A GSSAPI authentication provider for the Cassandra Java driver.
* [Instaclustr Minotaur](https://github.com/instaclustr/instaclustr-minotaur): Command line tool for consistent rebuilding of a Cassandra cluster.
* [Instaclustr LDAP Authenticator](https://github.com/instaclustr/cassandra-ldap): LDAP Authenticator for Apache Cassandra.
* [Instaclustr TTL Remover](https://github.com/instaclustr/cassandra-ttl-remover): Command line tool for rewriting SSTables to remove TTLs.
* [Instaclustr SSTable Generator](https://github.com/instaclustr/cassandra-sstable-generator): CLI tool for programmatic generation of Cassandra SSTables.
* [Instaclustr Exporter](https://github.com/instaclustr/cassandra-exporter): Java agent that exports Cassandra metrics to Prometheus.
* [Instaclustr Go Client for Instaclustr Icarus](https://github.com/instaclustr/instaclustr-icarus-go-client): Go client for Instaclustr Icarus sidecar.
* [Instaclustr SSTable Tools](https://github.com/instaclustr/cassandra-sstable-tools): A command line tool that helps admins get summaries, metadata, partition info, and cell info for SSTables.

### Cassandra Kubernetes operators

* [D2iQ Cassandra Kudo Operator](https://github.com/mesosphere/kudo-cassandra-operator): The KUDO Cassandra Operator makes it easy to deploy and manage Apache Cassandra on Kubernetes.
* [DataStax cass-operator](https://github.com/datastax/cass-operator): The DataStax Kubernetes Operator for Apache Cassandra
* [Instaclustr cassandra-operator](https://github.com/instaclustr/cassandra-operator): The Cassandra operator manages Cassandra clusters deployed to Kubernetes and automates tasks related to operating a Cassandra cluster.
* [Orange CassKop](https://orange-opensource.github.io/casskop/): The Orange Cassandra operator is a Kubernetes operator to automate provisioning, management, autoscaling and operations of Apache Cassandra clusters deployed to K8s.
* [Sky Cassandra Operator](https://github.com/sky-uk/cassandra-operator): The Sky Cassandra Operator is a Kubernetes operator that manages Cassandra clusters inside Kubernetes.

### Cassandra management sidecars

* [Apache Cassandra cassandra-sidecar](https://github.com/apache/cassandra-sidecar): Sidecar for the highly scalable Apache Cassandra database, built as part of the Apache Cassandra project.
* [DataStax Management API for Apache Cassandra](https://github.com/datastax/management-api-for-apache-cassandra): RESTful / Secure Management Sidecar for Apache Cassandra
* [DataStax Spring Boot](https://github.com/datastax/spring-boot): Spring Boot extension
* [Instaclustr Icarus](https://github.com/instaclustr/icarus): Icarus is meant to be run alongside of Cassandra, talking to Cassandra via JMX. Instaclustr Esop is embedded in Icarus for on-the-fly cluster backup and restore using various cloud storage providers as a source or destination. Icarus is used primarily as a backup and restore tool, and is containerized in [Instaclustr cassandra-operator](https://github.com/instaclustr/cassandra-operator) and [Orange CassKop](https://orange-opensource.github.io/casskop/).

### Developer Frameworks

* [Django Cassandra Engine](http://r4fek.github.io/django-cassandra-engine/): Cassandra backend for Django Framework that allows you to use Cqlengine directly in your project.
* [Express Cassandra](https://express-cassandra.readthedocs.io/en/stable/): Express-Cassandra is a Cassandra ORM/ODM/OGM for NodeJS with Elassandra & JanusGraph Support.
* [Quarkus extension for Apache Cassandra](https://quarkus.io/guides/cassandra): An Apache Cassandra(R) extension for Quarkus. Quarkus is A Kubernetes Native Java stack tailored for OpenJDK HotSpot and GraalVM, crafted from the best of breed Java libraries and standards.
* [Spring Data Cassandra](https://spring.io/projects/spring-data-cassandra): With the power to stay at a high level with annotated POJOs, or at a low level with high performance data ingestion capabilities, the Spring Data for Apache Cassandra templates are sure to meet every application need
* [TestContainers](https://www.testcontainers.org/modules/databases/cassandra/): Testcontainers is a Java library that supports JUnit tests, providing lightweight, throwaway instances of common databases, Selenium web browsers, or anything else that can run in a Docker container.

### Cassandra connectors 

#### Apache Kafka

* [Confluent Connect Cassandra](https://www.confluent.io/hub/confluentinc/kafka-connect-cassandra): The Confluent Cassandra Sink Connector is used to move messages from Kafka into Apache Cassandra.
* [DataStax Sink Connector](https://downloads.datastax.com/#akc): The DataStax Apache Kafka Connector automatically takes records from Kafka topics and writes them to a DataStax Enterprise or Apache Cassandra™ database. This sink connector is deployed in the Kafka Connect framework and removes the need to build a custom solution to move data between these two systems. 
* [Debezium Source Connector](https://github.com/debezium/debezium-incubator/tree/master/debezium-connector-cassandra): This connector is currently in incubating state, and Cassandra is different from the other Debezium connectors since it is not implemented on top of the Kafka Connect framework. 
* [Lenses Sink Connector](https://docs.lenses.io/connectors/sink/cassandra.html): The Cassandra Sink allows you to write events from Kafka to Cassandra. The connector converts the value from the Kafka Connect SinkRecords to JSON and uses Cassandra’s JSON insert functionality to insert the rows. The task expects pre-created tables in Cassandra.
* [Lenses Source Connector](https://docs.lenses.io/connectors/source/cassandra.html): Kafka Connect Cassandra is a Source Connector for reading data from Cassandra and writing to Kafka.

#### Apache Spark

* [DataStax Spark Cassandra Connector](https://github.com/datastax/spark-cassandra-connector): This library lets you expose Cassandra tables as Spark RDDs and Datasets/DataFrames, write Spark RDDs and Datasets/DataFrames to Cassandra tables, and execute arbitrary CQL queries in your Spark applications.

#### Apache Flink

* [Flink Sink Connector](https://ci.apache.org/projects/flink/flink-docs-stable/dev/connectors/cassandra.html): This connector provides sinks that writes data into a Apache Cassandra database.

#### Apache Pulsar

* [Pulsar Sink Connector](https://pulsar.apache.org/docs/en/io-quickstart/#connect-pulsar-to-cassandra): The Pulsar Cassandra Sink connector is used to write messages to a Cassandra Cluster.

#### Professional Support

* [DataStax Luna](https://luna.datastax.com/), [DataStax Premium Support](https://www.datastax.com/services/support/premium-support), [DataStax Professional Services](https://www.datastax.com/services/professional-services)
* [Instacluster](https://www.instaclustr.com/services/)
* [Open Credo](https://opencredo.com/about-us/)

