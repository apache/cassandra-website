#!/usr/bin/env bash

set -e

export CASSANDRA_SITE_DIR="/home/build/cassandra-site"

GREEN='\033[1;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Run a process in the background to correct the resource paths for the landing pages of each
# version in the publish directory
while [ 1 ]
do
    sed -i 's/\.\/\.\.\//\.\/\.\.\/\.\.\//g' ${CASSANDRA_SITE_DIR}/publish/doc/*/index.html
    sleep 5
done &

cd ${CASSANDRA_SITE_DIR}/src

JEKYLL_COMMAND="jekyll serve --host 0.0.0.0"

echo
echo "   Starting Jekyll: ${JEKYLL_COMMAND}"
echo "------------------------------------------------"
echo -e "${GREEN}      Site Address: http://127.0.0.1:4000/${NC}"
echo "------------------------------------------------"

${JEKYLL_COMMAND}
