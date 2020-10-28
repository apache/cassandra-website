#!/usr/bin/env bash

set -xe

export CASSANDRA_SITE_DIR="${BUILD_DIR}/cassandra-site"
export CASSANDRA_DIR="${BUILD_DIR}/cassandra"

jekyll --version

cd ${CASSANDRA_SITE_DIR}/src

# Now make the docs for the latest version
pushd ${CASSANDRA_DIR}
git clean -xdff
git checkout trunk
git pull --rebase --prune
popd
make .build-doc .latest-doc-link


# Uncomment for building docs for each of the released versions on the 3.11 branch, from 3.11.5 (previous don't work)
#
#versions="cassandra-3.11.5 cassandra-3.11.6 cassandra-3.11.7 cassandra-3.11.8"
#
#for v in $versions ; do
#  pushd ${CASSANDRA_DIR}
#  git clean -xdff
#  git checkout $v
#  popd
#  make .build-doc
#done

# Now make the docs for 3.11
pushd ${CASSANDRA_DIR}
git clean -xdff
git checkout cassandra-3.11
git pull --rebase --prune
popd
make .build-doc .stable-doc-link

# Relink the 3.11 version
LATEST_VERSION=$(basename $(find ./doc -iname 3.11* -type d | sort | tail -n 1))
rm -f doc/3.11
ln -s -f ${LATEST_VERSION} doc/3.11

# Generate the rest of the site
make build

# Fix the links in the resource paths for the landing pages of each version in the publish directory
cd ${CASSANDRA_SITE_DIR}
sed -i 's/\.\/\.\.\//\.\/\.\.\/\.\.\//g' ./publish/doc/*/index.html
