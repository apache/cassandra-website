Apache Cassandra website
========================

Development Cycle
-----------------

Making changes to the website is done with the following steps.

1. Test changes locally
2. Commit changes in `src/` to a fork and branch, and create a pull request
3. Get the pull request reviewed and merged to `master`
4. Preview the rendered site on https://cassandra.staged.apache.org/ (wait til [ci-cassandra.apache.org](https://ci-cassandra.apache.org/job/cassandra-website/) has deployed it)
5. Merge `asf-staging` to `asf-site`
6. View the rendered site on https://cassandra.apache.org/


To test changes before committing, it is a requirement that you build the website locally. Building the Apache Cassandra website takes a number of steps. To make things easier we have provided a Docker container which can build the full website in two simple commands and have it ready to commit via git. If you are interested in the process head over to the [README](./src/README) in _src_ directory.

Building Prerequisites
----------------------

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

Once building has completed, the site content will be in the `./cassandra-website/content` directory ready to be tested.


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

Merging `asf-staging` to `asf-site`
-----------------------------------

Updating the main website, after verifying the staged website, involves copying the `asf-staging` branch to `asf-site`. A normal git merge is not used, because the `asf-staging` is forced updated after each ci-cassandra.apache.org build. Instead make live the staged website by copying the `asf-staging` to the `asf-site` branch.

    git fetch origin
    git switch asf-site
    git reset --hard origin/asf-staging
    git push -f origin asf-site
