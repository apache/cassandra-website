---
layout: page
permalink: /download/
title: Download
is_homepage: false
is_sphinx_doc: false
---

Downloading Cassandra
---------------------

### Latest version

Cassandra is moving to a monthly release process called Tick-Tock. **Even-numbered** releases (e.g. 3.2) contain new
features; **odd-numbered** releases (e.g. 3.3) contain bug fixes only. If a critical bug is found, a patch will be
released against the most recent bug fix release. Read more about [tick-tock here](http://www.planetcassandra.org/blog/cassandra-2-2-3-0-and-beyond/).

Download the latest Cassandra release: {{ "latest" | full_release_link }}.

### Older supported releases

The following older Cassandra releases are still supported:

* Apache Cassandra 3.0 is supported until **May 2017**. The latest release is {{ "3.0" | full_release_link }}.
* Apache Cassandra 2.2 is supported until **November 2016**. The latest release is {{ "2.2" | full_release_link }}.
* Apache Cassandra 2.1 is supported until **November 2016** with **critical fixes only**. The latest release is
  {{ "2.1" | full_release_link }}.

Older (unsupported) versions of Cassandra are [archived here](http://archive.apache.org/dist/cassandra/).

### Debian™

The Apache Cassandra project also provide official Debian™ packages (which are not a product of Debian™). To use those
packages, you can use:

```
deb http://www.apache.org/dist/cassandra/debian <release series> main
deb-src http://www.apache.org/dist/cassandra/debian <release series> main
```

where `<release series>` is the series you want to install:

* For tick-tock releases, the `<release series>` is the release number, without dot, and with an appended `x`, so `31x`,
  `32x`, …
* For older pre-tick-tock releases, the `<release series>` is the major version number, without dot, and with an
  appended `x`. So currently it can one of `21x`, `22x` or `30x`.

If after running apt-get update, you see an error message like:

```
GPG error: http://www.apache.org unstable Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 0353B12C
```

you will need to add the public key of the current Cassandra “release manager”, here `0353B12C`. You can do that with:

``` shell
gpg --keyserver pgp.mit.edu --recv-keys <public key>
gpg --export --armor <public key> | sudo apt-key add -
```

where `<public key>` is the key to add (`0353B12C` in the example above). The list of Apache contributors public keys is
available at <https://www.apache.org/dist/cassandra/KEYS>.

Once set up, installing is done as usual with:

``` shell
sudo apt-get update
sudo apt-get install cassandra
```

Some things to be aware of:

* The configuration files are located in `/etc/cassandra`.
* Start-up options (heap size, etc) can be configured in `/etc/default/cassandra`.

### Third party distributions (not endorsed by Apache)

[DataStax Distribution of Apache Cassandra](http://www.planetcassandra.org/cassandra/) is available in Linux rpm, deb,
and tar packages, a Windows MSI installer, and a Mac OS X binary.

### Source

Development is done in the Apache Git repository. To check out a copy:

``` shell
git clone http://git-wip-us.apache.org/repos/asf/cassandra.git
```

[Bleeding edge development snapshots](http://cassci.datastax.com/job/trunk/lastSuccessfulBuild/) of Cassandra are
available from Jenkins continuous integration.
