# Apache Cassandra website

Tooling to build the Apache Cassandra website and documentation.

# tl;dr

```
$ git clone https://github.com/apache/cassandra-website.git
$ cd ./cassandra-website

# make sure you have docker installed

# website content edits are done in ./site-content/source/modules
# to build the website only using your local edits
$ ./run.sh website build

# open a browser window and navigate to site-content/build/html/_/index.html

# Cassandra document edits are in the Apache Cassandra project
$ git clone https://github.com/apache/cassandra.git
$ cd ./cassandra/

# in-tree Cassandra document edits are done in ./doc/modules
# to build the website and Cassandra documentation using your local edits
$ cd ../cassandra-website
$ ./run.sh website build -g -u cassandra:$(pwd)/../cassandra -b cassandra:<branch-with-your-changes>

# open a browser window and navigate to site-content/build/html/Cassandra/.../index.html
```

e.g.

```
$ ./run.sh website build -g -u cassandra:/Users/example/cassandra -b cassandra:example_branch
```

# Repository Layout

The website repository code is separated into two main parts. These parts are represented by the directories at the root level of the project. Specifically the structure of the repository is:

```
ROOT
  - site-content
  - site-ui
```

## Site UI

The 'site-ui' directory contains only the UI styling files that determines the look and feel of the site. A *ui-bundle.zip* file containing the styling information will be generated from the contents of this directory. Generation of the *ui-bundle.zip* will be done using `gulp` launched inside a Docker container.

## Site Content

The 'site-content' directory contains all the raw page information e.g. where to download, developer guidelines, how to commit patches, etc. The live website HTML is generated from the contents of this directory. Generation of the HTML content is done by `antora` launched inside a Docker container. As part of the website HTML generation, the ui-bundle.zip file, and the Cassandra documentation location are passed to `antora`. It uses the ui-bundle.zip to style the website. The Cassandra documentation location will be used to gather and generate documentation for each Cassandra version.

## Further Reading

For further details about why the directories are separated as described above and why we use `antora` please see the [Details](#details) section at the bottom of this page.

# Development Cycle

Making changes to the website content can be done using the following steps.

1. Preview changes locally. See below for further details about how to do this.
2. Commit changes in `site-content/source/html` to a fork and branch.
3. Create a pull request back to this repository.
3. Get the pull request reviewed and merged to `trunk`.
4. Preview the rendered site on https://cassandra.staged.apache.org/ (wait til [ci-cassandra.apache.org](https://ci-cassandra.apache.org/job/cassandra-website/) has deployed it).
5. Merge `asf-staging` to `asf-site`.
6. View the rendered site on https://cassandra.apache.org/.

# Developer Quickstart

To test changes before committing, it is a requirement that you build the website locally. Building the Apache Cassandra website takes a number of steps. To make things easier we have provided a suite of tools to build the full website in a few simple commands and have it ready to commit via git. Please see the [Details](#details) section at the bottom of this page for further details about the tooling.

## Building Prerequisites

To build and run the Docker container you will need `Docker` version 2.0.0.0 or greater. If you need a copy of the site code you will need `git` as well.

## Building the Website

If you need a copy of the site code run this command:

```bash
$ git clone https://github.com/apache/cassandra-website.git
$ cd ./cassandra-website
```

A `run.sh` wrapper script has been provided to simplify generating the docs and building the site. It provides a single commandline interface that generates the docker commands to run the website and UI docker containers.

The script has the following usage format

```bash
$ ./run.sh <COMPONENT> <COMMAND> [OPTIONS]
```

A complete list of components, commands and options can be found by running the following command.

```bash
$ ./run.sh -h
```

To build the website only, run the following command from within the `./cassandra-website` directory (assuming you used the above clone command).

```bash
$ ./run.sh website build
```

This will use the current checked-out branch of your cassandra-website local copy to build the website content. In addition, the local copy of the UI bundle will be used to style the website content. Use this command if you want to make a change to a top-level webpage without building the docs for any versions of cassandra.

Once building has completed, the HTML content will be in the `./site-content/build/html/` directory ready to be reviewed and committed.

:warning: *Tip:* In order to prevent root-owned modified files in your repository, the container executes operations as a non-root user. By default, the user is `build` and has the user and group permissions set to `UID=1000` and `GID=1000` respectfully. These permissions are usually the first user configured on a linux machine.

If your local user has different user and group permissions you can set up the container user with your local UID:GID. In addition, you can set the build user in the container your local username. These changes can be made when building the container using the following command:

```bash
$ ./run.sh website container -a BUILD_USER_ARG:$(whoami) -a UID_ARG:$(id -u) -a GID_ARG:$(id -g)
```

If you need to customise the container user as noted above, you must do this before you build the website or run any other website command.

## Building the Website with Versioned Documentation

To build the website with versioned documentation run the following command from within the `./cassandra-website` directory.

```bash
$ ./run.sh website build -g
```

# Build the Website when Developing

The website tooling is very flexible and allows for a wide range of development scenarios.

## Build the website from a different branch

You can tell the website builder to use a different branch to the one you are on. This can be done using the following command.

```bash
$ ./run.sh website build -b cassandra-website:my_branch
```

This will build the website content using your local copy of the cassandra-website, and the branch named `my_branch`.

## Build the website using a local clone of the repository

You can tell the website builder to use a different clone or fork of the repository.

To build using another local copy of the cassandra-website run the following command.

```bash
$ ./run.sh website build -u cassandra-website:/local/path/to/another/clone/of/cassandra-website
```

This will build the website using the contents of the local repository located in */local/path/to/another/clone/of/cassandra-website*

## Build the website using a remote clone of the repository

To build using a remote copy of the cassandra-website run the following command.

```bash
$ ./run.sh website build -u cassandra-website:https://github.com/my_orgranisation/cassandra-website.git
```

This will build the website using the contents of the remote repository located at *https://github.com/my_orgranisation/cassandra-website.git*

:warning: *Tip:* The `HEAD` branch of the Cassandra Website repository is always used by default unless an alternative branch is specified.

In both cases above the `HEAD` branch is used and translates to different branches. In first case where the repository is local, `HEAD` will translate to the currently checked out branch. In the second case where the repository is remote and needs to be cloned, `HEAD` will translate to default branch selected when the repository is cloned. You can specify a different branch using the `-b` option as per the example in [Build a different branch](#build-a-different-branch).

## Previewing the Website

An offline preview mode exists if you want to view the website as you make changes to the content. Preview mode can be launched using the following command.

```bash
$ ./run.sh website preview
```

The site can be viewed on [http://localhost:5151](http://localhost:5151).

The `preview` command operates the same as the `build` command. It will build the website content using your local copy of the cassandra-website, and the current checked-out branch. Additionally, it will then start a webserver to serve the HTML and a process that monitors the content files in your local copy of the repository. If a change is made to a content file, the website HTML will automatically be regenerated.

Press `Ctrl+C` to stop the preview server and end the continuous build.

:warning: *Tip:* You may need to refresh your browser when the auto rendering of the site is complete.

All options that are available in the `build` command can be used by the `preview` command. Hence, the options used in the previous examples can be specified when using the `preview` command.

# Developer Advanced Usage Guide

The cassandra-website tooling can also be used to perform a number of other operations:

* Generate the Apache Cassandra documentation alone.
* Update the website styling and behaviour.

## Generating the Cassandra Documentation

The website tooling provides the ability to generate the Cassandra AsciiDoc (.adoc) files. The content of the AsciiDoc files are sourced from nodetool and the cassandra.yaml configuration file. The AsciiDoc files need to exist in the Cassandra repository as either commits to the branch or changes ready to be committed before `antora` can generate the HTML formatted equivalent for publication to the Cassandra website.

By default, the Docker container that generates the version documentation will clone the Apache Cassandra project within the container when generating the documentation. The document generation process commits the generated AsciiDoc to this repository. This is done so `antora` can generate website HTML as well as the HTML for the various versions of the documentation using the committed AsciiDoc in each branch.

You can use your own local copy or fork of the Cassandra repository as the source for the versioned documentation. Doing this will also allow you to view and access the generated AsciiDoc files. To use your own copy or fork of the Cassandra repository, you can specify a local path to the `run.sh` script. In this case, when rendering multiple versions of the documentation, any changes to the generated AsciiDoc files will be committed to your local copy or fork. If multiple source branches are specified, commits will be made to each branch.

### Generate documentation using a local clone of the repository

To generate the latest version of the Cassandra docs using a local copy or fork of the Cassandra repository, run the following command.

```bash
$ ./run.sh website docs -u cassandra:/local/path/to/cassandra/repository -b cassandra:trunk
```

The output of this command will be AsciiDoc (`.adoc`) files that `antora` can render into HTML. Note that `antora` is never executed when only the Cassandra versioned documentation is generated.

If you are generating only the Cassandra version documentation, you should always specify a local copy of a Cassandra repository. This is because the generated AsciiDoc files will be placed in the Cassandra directory or committed to the branch used to generate them. You will then be able to view the contents of the AsciiDoc files.

If you are generating only the Cassandra version documentation, and you specify a remote Cassandra repository location, the generated AsciiDoc files will be inaccessible. This is because the Cassandra repository will be cloned inside the container before the AsciiDoc files are generated. In this case a warning message will be displayed, and you will be asked whether to proceed with the operation. Specifying a remote Cassandra repository location is useful in cases where the HTML website is generated as well. See [Generating the website and versioned documentation HTML at the sametime](#generating-the-website-and-versioned-documentation-html-at-the-sametime).

### Generate documentation for multiple Cassandra versions

To generate multiple versions of the Cassandra documentation using a local copy or fork of the Cassandra repository, run the following command.

```bash
$ ./run.sh website docs -u cassandra:/local/path/to/cassandra/repository -b cassandra:trunk,cassandra-3.11,my_branch
```

In the above command, multiple branches separated by a comma (`,`) can be specified in the `-b` option.

## Generating the website and versioned documentation HTML at the sametime

The website tooling can be used to run a complete end-to-end generation of the HTML website and versioned documentation. That is, it can first generate the AsciiDoc files for each Cassandra version, and then launch `antora` to generate the HTML website and versioned documentation for publication.

### Generate the website and documentation from a local repositories

You can use a local copy of the Cassandra repository as the source for the documentation.

To build the website using a local clone of the Cassandra repository run the following command.

```bash
$ ./run.sh \
  website \
  build \
    -g \
    -u cassandra:/local/path/to/cassandra/repository \
    -u cassandra-website:/local/path/to/cassandra-website/repository
```

In the above command, the `-g` option is used to tell the tooling to generate the non-committed AsciiDoc files and include the Cassandra repository as a source when `antora` is generating the HTML. This ensures the complete versioned documentation HTML is generated along with the website HTML.

### Generate the website and documentation from a remote repositories

To build using a remote copy of the Cassandra repository that contains the generated AsciiDoc files, and the Cassandra Website run the following command.

```bash
$ ./run.sh \
  website \
  build \
    -g \
    -u cassandra:https://github.com/my_orgranisation/cassandra.git \
    -u cassandra-website:https://github.com/my_orgranisation/cassandra-website.git
```

You can have a combination of local and remote repository paths. For example, you could have a local copy of the Cassandra Website repository and want to use the remote Cassandra repository to include the current documentation when rendering the website. To do this you can run the following command.

```bash
$ ./run.sh \
  website \
  build \
    -g \
    -u cassandra:https://github.com/my_orgranisation/cassandra.git \
    -u cassandra-website:/local/path/to/cassandra-website/repository
```

### Generate the website using your own copy of the ui-bundle

By default, the local copy of the *ui-bundle.zip* located in site-ui/build/ is used by Antora to style the website when it is built. The `./run.sh` script will pass the location of ui-bundle.zip to the Docker container that executes Antora.

You can use your own *ui-bundle.zip* file containing the information on how to style the website when building it. The *ui-bundle.zip* file can be generated using the `./run.sh` script. See the [Building the Site UI](#building-the-site-ui) section for further details on how to build the *ui-bundle.zip*.

To supply your own *ui-bundle.zip* file when building the website, run the following command.

```bash
$ ./run.sh website build -z /local/path/to/ui-bundle.zip
```

The path to the *ui-bundle.zip* file can also be a remote URL. You can supply the URL using the following command.

```bash
$ ./run.sh website build -z https://github.com/apache/cassandra-website/archive/refs/tags/ui-bundle-1.0.zip
```

The styling contained in the *ui-bundle.zip* will be applied to docs if they are being rendered as well.

## Building the Site UI

To get a list of the tasks that can be executed, run the following commands.

```bash
$ ./run.sh website-ui
```

A task can be executed using the following commands:

```bash
$ ./run.sh website-ui <task>
```

A full list of tasks can be found by running the following command

```bash
$ ./run.sh website-ui tasks
```

### Building Bundle

Antora needs a *ui-bundle.zip* when rendering the website and documentation content. It contains CSS, Java Script, fonts, images and other assets which define the look and feel of the website.

To generate the *ui-bundle.zip* from the assets in the *site-ui* directory, run the following command.

```bash
$ ./run.sh website-ui bundle
```

This will build the UI Bundle using your local copy of the styling assets located in *./site-ui/*.

When packaged successfully, the *ui-bundle.zip* will be located in the *./site-ui/build/* directory of the repository.

:warning: *Tip:* In order to prevent root-owned modified files in your repository, the container executes operations as a non-root user. By default, the user is `build` and has the user and group permissions set to `UID=1000` and `GID=1000` respectfully. These permissions are usually the first user configured on a linux machine.

If your local user has different user and group permissions you can set up the container user with your local UID:GID. In addition, you can set the build user in the container your local username. These changes can be made when building the container using the following command:

```bash
$ ./run.sh website-ui container -a BUILD_USER_ARG:$(whoami) -a UID_ARG:$(id -u) -a GID_ARG:$(id -g)
```

If you need to customise the container user as noted above, you must do this before you build the UI Bundle or run any other website-ui command.

### Preview UI

An offline preview mode exists if you want to view example website content as you make changes to the UI. Preview mode can be launched using the following command.

```bash
$ ./run website-ui preview
```

The example content can be viewed on [http://localhost:5252](http://localhost:5252).

While preview mode is running, any changes you make to the source files will be instantly reflected in the browser. This works by monitoring the project for changes, running the build task if a change is detected, and sending the updates to the browser.

The files in the *preview-src/* folder provide the sample content that allow you to see the UI in action. In this folder, you will primarily find pages written in AsciiDoc. These pages provide a representative sample and kitchen sink of content from the real site.

Press `Ctrl+C` to stop the preview server and end the continuous build.

# Merging `asf-staging` to `asf-site`

Updating the main website, after verifying the staged website, involves copying the `asf-staging` branch to `asf-site`. A normal git merge is not used, because the `asf-staging` is forced updated after each ci-cassandra.apache.org build. Instead make live the staged website by copying the `asf-staging` to the `asf-site` branch.

    git fetch origin
    git switch asf-site
    git reset --hard origin/asf-staging
    git push -f origin asf-site

# Details

## Tooling components

The tooling is made up of the following components

* Run script: `./run.sh` - Provides a single commandline interface that generates the docker commands to run the website and UI docker containers. Using the containers, it can build the Cassandra website UI components, generate the Cassandra versioned documentation, and generate the website HTML.
* Website Docker container: `site-content/Dockerfile` and `site-content/docker-entrypoint.sh` - Contains the libraries necessary to generate the Cassandra versioned documentation, and generate the website HTML using Antora.
* Antora Site YAML script: `bin/site_yaml_generator.py` - Used by the Website Docker container to create the YAML file that defines the sources for the website content, optionally the cassandra versioned documentation, and the UI styling bundle to apply.
* Website UI Docker container: `site-ui/Dockerfile` and `site-ui/docker-entrypoint.sh` - Contains the libraries necessary to generate the UI bundle ZIP file the is applied by Antora to style the website and documentation.

## Why is Antora being used

Antora is being used for the website generation because it is designed to create websites that have version documentation. For example, when a new version of Cassandra is released, a new version of the documentation will be generated as well. Hence, if there is a change in the behaviour of Cassandra or a tool in the project, it will be captured in the latest version of the documentation. Users of the project will have the ability to select the version of the documentation they are interested in.

## Why is the styling separated from the content

Separating the layout/style, and the content means that stying changes can be made with little to no impact on content and vice-versa. In addition, changes to the styling can happen in parallel while website content is updated without conflict.