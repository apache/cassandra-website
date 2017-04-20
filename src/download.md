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

* Apache Cassandra 3.0 is supported until **6 months after 4.0 release (date TBD)**. The latest release is {{ "3.0" | full_release_link }}.
* Apache Cassandra 2.2 is supported until **4.0 release (date TBD)**. The latest release is {{ "2.2" | full_release_link }}.
* Apache Cassandra 2.1 is supported until **4.0 release (date TBD)** with **critical fixes only**. The latest release is
  {{ "2.1" | full_release_link }}.

Older (unsupported) versions of Cassandra are [archived here](http://archive.apache.org/dist/cassandra/).

### Installation from Debian packages

* For tick-tock releases, the `<release series>` is the release number, without dot, and with an appended `x`, so `31x`,
  `32x`, …
* For older pre-tick-tock releases, the `<release series>` is the major version number, without dot, and with an
  appended `x`. So currently it can one of `21x`, `22x` or `30x`.

* Add the Apache repository of Cassandra to `/etc/apt/sources.list.d/cassandra.sources.list`, for example for version 3.10:

```
echo "deb http://www.apache.org/dist/cassandra/debian 310x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
```

* Add the Apache Cassandra repository keys:

```
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
```

* Update the repositories:

```
sudo apt-get update
```

* If you encounter this error:

```
GPG error: http://www.apache.org 310x InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A278B781FE4B2BDA
```
Then add the public key A278B781FE4B2BDA as follows:

```
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
```
and repeat `sudo apt-get update`. The actual key may be different, you get it from the error message itself. For a
full list of Apache contributors public keys, you can refer to <https://www.apache.org/dist/cassandra/KEYS>.

* Install Cassandra:

```
sudo apt-get install cassandra
```

* You can start Cassandra with `sudo service cassandra start` and stop it with `sudo service cassandra stop`.
  However, normally the service will start automatically. For this reason be sure to stop it if you need to make any
  configuration changes.
* Verify that Cassandra is running by invoking `nodetool status` from the command line.
* The default location of configuration files is `/etc/cassandra`.
* The default location of log and data directories is `/var/log/cassandra/` and `/var/lib/cassandra`.
* Start-up options (heap size, etc) can be configured in `/etc/default/cassandra`.

### Installation from RPM packages

Cassandra can currently only be installed manually from downloaded RPM packages. We'll work on making upcoming releases available through repositories in the future.

The following versions are currently available for download:

* [3.0.13](http://www.apache.org/dyn/closer.lua/cassandra/redhat/30x/cassandra-3.0.13-1.noarch.rpm) (md5: `7a100653112a8a79d09fbf18dbc3f7d8` sha1: `3b9e2dfa94614af7d7f7891eb95982719e1a8fb4`)

Any instructions have been tested with CentOS 7 and should work for all Redhat based distributions. Please see note on end of this section on how to report any issues.

Start Cassandra (will not start automatically):

```
service cassandra start
```

Systemd based distributions may require to run `systemctl daemon-reload` once to make Cassandra available as a systemd service. This should happen automatically by running the command above.

Make Cassandra start automatically after reboot:

```
chkconfig cassandra on
```

Please note that official RPMs for Apache Cassandra only have been available recently and are not tested thoroughly on all platforms yet. We appreciate your feedback and support and ask you to post details on any issues in the [corresponding Jira ticket](https://issues.apache.org/jira/browse/CASSANDRA-13433).



### Source

Development is done in the Apache Git repository. To check out a copy:

```
git clone http://git-wip-us.apache.org/repos/asf/cassandra.git
```
