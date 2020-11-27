#!/bin/bash

# Abort script if a command fails
set -e

#
# Tasks
#
# docs (generate docs)
# build (render site)
# preview (preview site)
# publish (publish site to asf-site branch)
#

export CASSANDRA_USE_JDK11=true
CASSANDRA_WEBSITE_DIR="${BUILD_DIR}/cassandra-website"
CASSANDRA_DIR="${BUILD_DIR}/cassandra"
CASSANDRA_DOC="${CASSANDRA_DIR}/doc"
GIT_USER_SETUP="false"

setup_git_user() {
  if [ "${GIT_USER_SETUP}" = "false" ]
  then
    # Setup git so we can commit back to the Cassandra repository locally
    git config --global user.email "${GIT_EMAIL_ADDRESS}"
    git config --global user.name "${GIT_USER_NAME}"
    GIT_USER_SETUP="true"
  fi
}

generate_cassandra_versioned_docs() {
  setup_git_user

  for version in ${CASSANDRA_VERSIONS}
  do
    echo "Checking out branch '${version}'"
    pushd "${CASSANDRA_DIR}"
    git clean -xdff
    git checkout "${version}"
    git pull --rebase --prune

    echo "Building JAR files"
    # Nodetool docs are autogenerated, but that needs nodetool to be built
    ant jar
    doc_version=$(ant echo-base-version | grep "\[echo\]" | tr -s ' ' | cut -d' ' -f3)
    popd

    pushd "${CASSANDRA_DOC}"

    # cassandra-3.11 is missing gen-nodetool-docs.py, ref: CASSANDRA-16093
    gen_nodetool_docs=$(find . -iname gen-nodetool-docs.py | head -n 1)
    if [ ! -f "${gen_nodetool_docs}" ]
    then
      echo "Unable to find ${gen_nodetool_docs}, so I will download it from the Cassandra repository using commit a47be7e."
      wget \
        -nc \
        -O ./gen-nodetool-docs.py \
        https://raw.githubusercontent.com/apache/cassandra/a47be7eddd5855fc7723d4080ca1a63c611efdab/doc/gen-nodetool-docs.py
    fi

    echo "Generating asciidoc for version ${doc_version}"
    # generate the nodetool docs
    python3 "${gen_nodetool_docs}"

    # generate cassandra.yaml docs
    convert_yaml_to_adoc=$(find . -iname convert_yaml_to_adoc.py | head -n 1)
    if [ -f "${gen_nodetool_docs}" ]
    then
      YAML_INPUT="${CASSANDRA_DIR}/conf/cassandra.yaml"
      YAML_OUTPUT="${CASSANDRA_DOC}/source/modules/cassandra/pages/configuration/cass_yaml_file.adoc"
      python3 "${convert_yaml_to_adoc}" "${YAML_INPUT}" "${YAML_OUTPUT}"
    fi

    git add .
    git commit -m "Generated nodetool and configuration documentation for ${doc_version}."
    popd
  done
}

render_site_content_to_html() {
  cd "${CASSANDRA_WEBSITE_DIR}/site-content"
  echo "Building site.yaml"
  rm -f site.yaml
  python3 ./bin/site_yaml_generator.py \
    -s "{\"title\":\"${SITE_TITLE}\",\"url\":\"${SITE_URL}\",\"start_page\":\"${SITE_START_PAGE}\"}" \
    -c "{\"url\":\"${CASSANDRA_REPOSITORY_URL}\",\"branches\":[$(echo \""${CASSANDRA_VERSIONS}"\" | sed 's~\ ~\",\"~g')],\"start_path\":\"${CASSANDRA_START_PATH}\"}" \
    -c "{\"url\":\"${CASSANDRA_WEBSITE_REPOSITORY_URL}\",\"branches\":[$(echo \""${CASSANDRA_WEBSITE_VERSIONS}"\" | sed 's~\ ~\",\"~g')],\"start_path\":\"${CASSANDRA_WEBSITE_START_PATH}\"}" \
    -u "${UI_BUNDLE_ZIP_URL}" \
    -r "${CASSANDRA_DOWNLOADS_URL}" \
    site.template.yaml

  echo "Building the site HTML content."
  export DOCSEARCH_ENABLED=true
  export DOCSEARCH_ENGINE=lunr
  export NODE_PATH="$(npm -g root)"
  export DOCSEARCH_INDEX_VERSION=latest
  antora --generator antora-site-generator-lunr site.yaml
}

if [ "${GENERATE_CASSANDRA_VERSIONED_DOCS}" = "enabled" ]
then
  generate_cassandra_versioned_docs
fi

if [ "${RENDER_SITE_HTML_CONTENT}" = "enabled" ]
then
  render_site_content_to_html
fi


#if [ "${BUILD_MODE}" = "preview" ]
#then
#  echo "Starting webserver."
#  python3 -m http.server "${WEB_SERVER_PORT}"
#fi
