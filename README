Apache Cassandra website builder
================================

Building the Apache Cassandra website takes a number of steps. To make things easier we have provided a Docker container which can build the full website in two simple commands and have it ready to commit via git. If you are interested in the process head over to the [README](./src/README) in _src_ directory.

Prerequisite
------------

To build and run the Docker container you will need `Docker` version 2.0.0.0 or greater. If you need a copy of the site code you will need `git` as well.


Building the site
-----------------

If you need a copy of the site code run this command:

```bash
$ git clone https://github.com/apache/cassandra-website.git
$ cd ./cassandra-website

```

To build the website run the following commands from within the _./cassandra-website_ directory (assuming you used the above checkout commands):

```bash
$ docker-compose build cassandra-website
$ docker-compose run cassandra-website
```

Go make yourself a cup of coffee, this will take a while...

Once building has completed, the site content will be in the _./cassandra-website/publish_ directory ready to be committed.


Previewing the site
-------------------

If you want to preview the site as you are editing it run this command:

```bash
$ docker-compose build cassandra-website
$ docker-compose up cassandra-website-serve
```

For information about the site layout see the **Layout** section of [README](src/README#layout) in the _src_ directory.