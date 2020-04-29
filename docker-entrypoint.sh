#!/usr/bin/env bash

set -xe

export CASSANDRA_SITE_DIR="/home/build/cassandra-site"

jekyll --version

# Make sure we have the latest commit of Cassandra trunk
cd ${CASSANDRA_DIR}
git checkout trunk
git pull --rebase --prune

# Now make the docs for the latest version
cd ${CASSANDRA_SITE_DIR}/src
make add-latest-doc


# Make sure we have the latest commit of Cassandra 3.11
pushd ${CASSANDRA_DIR}
ant realclean
git checkout cassandra-3.11
git pull --rebase --prune
popd

# Now make the docs for 3.11
make .build-doc

# Relink the 3.11 version
LATEST_VERSION=$(basename $(find ./doc -iname 3.11* -type d | sort | tail -n 1))
rm -f doc/3.11
ln -s -f ${LATEST_VERSION} doc/3.11

make build


# Generate the rest of the site
make

# Fix the links in the resource paths for the landing pages of each version in the publish directory
cd ${CASSANDRA_SITE_DIR}
sed -i 's/\.\/\.\.\//\.\/\.\.\/\.\.\//g' ./publish/doc/*/index.html
