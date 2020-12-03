# Apache Cassandra website

TODO: Add notes about the repository structure

## Development Cycle

Making changes to the website content can be done using the following steps.

1. Preview changes locally. See below for further details about how to do this.
2. Commit changes in `site-content/source` to a fork and branch.
3. Create a pull request back to this repository.
3. Get the pull request reviewed and merged to `trunk`.
4. Preview the rendered site on https://cassandra.staged.apache.org/ (wait til [ci-cassandra.apache.org](https://ci-cassandra.apache.org/job/cassandra-website/) has deployed it).
5. Merge `asf-staging` to `asf-site`.
6. View the rendered site on https://cassandra.apache.org/.

# Developer Quickstart

To test changes before committing, it is a requirement that you build the website locally. Building the Apache Cassandra website takes a number of steps. To make things easier we have provided a Docker container which can build the full website in a few simple commands and have it ready to commit via git.

## Building Prerequisites

To build and run the Docker container you will need `Docker` version 2.0.0.0 or greater. If you need a copy of the site code you will need `git` as well.

## Building the Website

If you need a copy of the site code run this command:

```bash
$ git clone https://github.com/apache/cassandra-website.git
$ cd ./cassandra-website
```

To build the website run the following commands from within the `./cassandra-website` directory (assuming you used the above clone command):

```bash
$ export BUILD_USER=build
$ docker-compose build website
$ docker-compose run website
```

:warning: *Tip:* In order to prevent root-owned modified files in your repository, the container user, `build`, is set up with a default UID=1000:GID=1000, which is usually the first user configured on a linux machine. If your local user is different you should set up the container user with your local host user's UID:GID, replace the above with:

```bash
$ export BUILD_USER=build
$ docker-compose build --build-arg UID_ARG=$(id -u) --build-arg GID_ARG=$(id -g) website
$ docker-compose run website
```

Once building has completed, the site content will be in the `./cassandra-website/site-content/build` directory ready to be tested.

### Customising the Website Build for Development

#### You can use your own Cassandra fork

The container contains a local copy of the Apache Cassandra repository. The document generation process commits the generated AsciiDoc to the local repository. This is done to allow Antora to render to HTML the versioned documentation and website using the committed AsciiDoc in each branch.

If you have a Cassandra fork you would like to use instead, you can override the repository used when building the container:

```
$ export BUILD_USER=build
$ docker-compose build --build-arg CASSANDRA_REPOSITORY_URL_ARG=<git_url_to_your_fork> website
$ docker-compose run website
```

Note that you can specify multiple `--build-arg` options when calling `docker-compose build`. So if you wanted to use a different user ID, group ID and repository you could run the following command:

```
$ export BUILD_USER=build
$ docker-compose build \
  --build-arg CASSANDRA_REPOSITORY_URL_ARG=<git_url_to_your_fork> \
  --build-arg UID_ARG=$(id -u) \
  --build-arg GID_ARG=$(id -g) \
  website
$ docker-compose run website
```

In addition to customising the container build, you can customise the environment variables used inside the container. These can be used to influence Antora's rending of the site. For example, Antora will generate documentation for all Cassandra releases starting at 3.11.5. Hence, if you have a specific branch in your fork of Cassandra that you would like to render, you can override the variable the specifies the branches to render.

TODO: Explain that you need an env.dev file with variables in it and to run `docker-compose run website-dev`

Below is a select list of environment variables that can be overridden to control Antora's rendering of the site and why you would want to override them.

TODO: Add reason why you would override these
`CASSANDRA_REPOSITORY_URL`
`CASSANDRA_VERSIONS`
`CASSANDRA_WEBSITE_REPOSITORY_URL`
`CASSANDRA_WEBSITE_VERSIONS`
`UI_BUNDLE_ZIP_URL`



# WARNING: From here on is all wrong!!!!

### Previewing the Website Build

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


## Building the Site UI

### Executing Tasks

To get a list of the tasks that can be executed run the following commands:

```
$ export BUILD_USER=build
$ docker-compose build website-ui:
$ docker-compose run website-ui
```

A task can be executed using the following commands:

```bash
$ export BUILD_USER=build
$ docker-compose build website-ui:
$ docker-compose run website-ui <task>
```

### Building Bundle

TODO: Add info

### Releasing Bundle

TODO: Add info

### Preview UI

```bash
$ export BUILD_USER=build
$ docker-compose build website-ui-preview
$ docker-compose up website-ui-preview
```