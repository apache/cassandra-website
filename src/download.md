---
layout: page
permalink: /download/
title: Download
is_homepage: false
is_sphinx_doc: false
---

Downloading Cassandra
---------------------

### Latest Beta Version

Download the latest Apache Cassandra 4.0 beta release: {{ "latest" | full_release_link }}.

### Latest Stable Version

Download the latest Apache Cassandra 3.11 release: {{ "3.11" | full_release_link }}.

### Older Supported Releases

The following older Cassandra releases are still supported:

* Apache Cassandra 3.0 is supported until **6 months after 4.0 release (date TBD)**. The latest release is {{ "3.0" | full_release_link }}.
* Apache Cassandra 2.2 is supported until **4.0 release (date TBD)**. The latest release is {{ "2.2" | full_release_link }}.
* Apache Cassandra 2.1 is supported until **4.0 release (date TBD)** with **critical fixes only**. The latest release is
  {{ "2.1" | full_release_link }}.

Older (unsupported) versions of Cassandra are [archived here](http://archive.apache.org/dist/cassandra/).

### Installation from Debian packages

* For the `<release series>` specify the major version number, without dot, and with an appended `x`.
* The latest `<release series>` is `311x`.
* For older releases, the `<release series>` can be one of `30x`, `22x`, or `21x`.

* Add the Apache repository of Cassandra to `/etc/apt/sources.list.d/cassandra.sources.list`, for example for the latest 3.11 version:

```
echo "deb https://downloads.apache.org/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
```

* Add the Apache Cassandra repository keys:

```
curl https://downloads.apache.org/cassandra/KEYS | sudo apt-key add -
```

* Update the repositories:

```
sudo apt-get update
```

* If you encounter this error:

```
GPG error: http://www.apache.org 311x InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A278B781FE4B2BDA
```
Then add the public key A278B781FE4B2BDA as follows:

```
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
```
and repeat `sudo apt-get update`. The actual key may be different, you get it from the error message itself. For a
full list of Apache contributors public keys, you can refer to <https://downloads.apache.org/cassandra/KEYS>.

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

* For the `<release series>` specify the major version number, without dot, and with an appended `x`.
* The latest `<release series>` is `311x`.
* For older releases, the `<release series>` can be one of `30x`, `22x`, or `21x`.
* (Not all versions of Apache Cassandra are available, since building RPMs is a recent addition to the project.)

* Add the Apache repository of Cassandra to `/etc/yum.repos.d/cassandra.repo`, for example for the latest 3.11 version:

```text
[cassandra]
name=Apache Cassandra
baseurl=https://downloads.apache.org/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
```

* Install Cassandra, accepting the gpg key import prompts:

```
sudo yum install cassandra
```

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
git clone https://gitbox.apache.org/repos/asf/cassandra.git
```
