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

To build the website run the following commands from within the `./cassandra-website` directory (assuming you used the above clone command):

```bash
$ docker-compose build cassandra-website
$ docker-compose run cassandra-website
```

:warning: *Tip:* In order to prevent root-owned modified files in your repository, the container user, `build`, is set up with a default UID=1000:GID=1000, which is usually the first user configured on a linux machine. If your local user is different you should set up the container user with your local host user's UID:GID, replace the above with:

```bash
$ docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) cassandra-website
$ docker-compose run cassandra-website
```

Go make yourself a cup of coffee, this will take a while...

Once building has completed, the site content will be in the `./cassandra-website/content` directory ready to be committed.


Previewing the site
-------------------

The fastest way to preview the site is to run the following:

```bash
$ docker-compose up preview
```

Then view the site on http://localhost:8000

If you want to preview the site as you are editing it run this command:

```bash
$ docker-compose build cassandra-website
$ docker-compose up cassandra-website-serve
```

For information about the site layout see the **Layout** section of [README](src/README#layout) in the _src_ directory.
