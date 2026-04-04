FROM ubuntu:22.04

# Set up non-root user, 'build', with default uid:gid
# This allows passing --build-arg to use localhost username, and uid:gid:
#   $ docker build \
#       -t cassandra-website:latest \
#       --build-arg BUILD_USER_ARG=$(whoami) \
#       --build-arg UID_ARG=$(id -u) \
#       --build-arg GID_ARG=$(id -g) \
#
#
# For developer convenience (to avoid having to run `./run.sh website container`) publish trunk changes to dockerhub with:
# `docker buildx build --platform linux/amd64,linux/arm64 -f ./site-content/Dockerfile -t apache/cassandra-website:latest --provenance=true --sbom=true --push  ./site-content/`
#
ARG BUILD_USER_ARG="build"
ARG UID_ARG=1000
ARG GID_ARG=1000

# GO_VERSION_SHAS must contain contain a matching sha256 for the $GO_VERSION download.  there should only be four SHAs listed.
ARG GO_VERSION="1.26.1"
ARG GO_VERSION_SHAS="031f088e5d955bab8657ede27ad4e3bc5b7c1ba281f05f245bcc304f327c987a a290581cfe4fe28ddd737dde3095f3dbeb7f2e4065cab4eae44dfc53b760c2f7 65773dab2f8cc4cd23d93ba6d0a805de150ca0b78378879292be0b903b8cdd08 353df43a7811ce284c8938b5f3c7df40b7bfb6f56cb165b150bc40b5e2dd541f"

ENV BUILD_USER=${BUILD_USER_ARG}
ENV BUILD_DIR="/home/${BUILD_USER}"
ENV NPM_CONFIG_LOGLEVEL info

RUN echo "Building with arguments:" \
    && echo " - BUILD_USER_ARG=${BUILD_USER_ARG}" \
    && echo " - UID_ARG=${UID_ARG}" \
    && echo " - GID_ARG=${GID_ARG}" \
    && echo " - NODE_VERSION_ARG=${NODE_VERSION_ARG}" \
    && echo " - ENTR_VERSION_ARG=${ENTR_VERSION_ARG}"

# INSTALL wget, python3, java11, and other tools required to build the docs
RUN apt update && \
    apt install -y \
        openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk openjdk-21-jdk \
        python3 python3-pip ant ant-optional make git gpg wget curl \
        gcc sudo pandoc

# install golang.  GO_VERSION_SHA must be updated with VERSION
RUN sh -c '\
  set -ex ;\
  GO_OS=linux ;\
  [ $(uname) = "Darwin" ] && GO_OS=darwin ;\
  GO_PLATFORM=amd64 ;\
  [ $(uname -m) = "aarch64" ] && GO_PLATFORM=arm64 ;\
  GO_TAR="go${GO_VERSION}.${GO_OS}-${GO_PLATFORM}.tar.gz" ;\
  curl -L --fail --silent --retry 2 --retry-delay 5 --max-time 30 https://go.dev/dl/$GO_TAR -o $GO_TAR ;\
  GO_SHA="$(sha256sum $GO_TAR | cut -d" " -f2)" ;\
  echo "$GO_VERSION_SHAS" | sed "s/ /\n/g" | grep -q "$GO_SHA" || { echo "SHA256 mismatch for $GO_TAR $GO_SHA"; exit 1; } ;\
  tar -C /usr/local -xzf $GO_TAR ;\
  rm $GO_TAR'

ENV GOROOT="/usr/local/go"
ENV GOPATH="$BUILD_DIR/bin"
ENV PATH="$PATH:/usr/local/go/bin"

RUN pip3 install jinja2 requests
RUN ln -s /usr/bin/python3 /usr/bin/python


# Install Node.js for Antora (documentation generation)
RUN sh -c '\
  set -ex ;\
  NODE_VERSION="v20.16.0" ;\
  NODE_PLATFORM=x64 ;\
  [ $(uname -m) = "aarch64" ] && NODE_PLATFORM=arm64 ;\
  NODE_VERSION_SHAS="c30af7dfea46de7d8b9b370fa33b8b15440bc93f0a686af8601bbb48b82f16c0 1d9929e72f692179f884cd676b2dfabd879cb77defa7869dc8cfc802619277fb" ;\
  NODE_TAR="node-${NODE_VERSION}-linux-${NODE_PLATFORM}.tar.xz" ;\
  wget -q "https://nodejs.org/dist/${NODE_VERSION}/${NODE_TAR}" --no-check-certificate ;\
  NODE_SHA="$(sha256sum ${NODE_TAR} | cut -d" " -f1)" ;\
  echo "$NODE_VERSION_SHAS" | sed "s/ /\n/g" | grep -q "$NODE_SHA" || { echo "SHA256 mismatch for ${NODE_TAR} ${NODE_SHA}"; exit 1; } ;\
  tar -xJf "${NODE_TAR}" -C /usr/local --strip-components=1 ;\
  rm "${NODE_TAR}" ;\
  ln -s /usr/local/bin/node /usr/local/bin/nodejs'

CMD [ "npm", "--version" ]

# Use npm to install Antora globally, and antora-lunr for site search, and js-yaml to load YAML files
RUN npm i -g @antora/cli@2.3 @antora/site-generator-default@2.3 @djencks/asciidoctor-openblock
RUN npm i -g antora-lunr antora-site-generator-lunr
RUN npm i -g live-server

# Create the build user and make it part of the password-less sudo group
RUN groupadd --gid ${GID_ARG} --non-unique ${BUILD_USER} && \
    useradd --create-home --shell /bin/bash --uid ${UID_ARG} --gid ${GID_ARG} --non-unique ${BUILD_USER} && \
    usermod -aG sudo ${BUILD_USER} && \
    sed -i 's/\(^%sudo\tALL=(ALL:ALL)\).*/\1 NOPASSWD:ALL/g' /etc/sudoers

# Setup directories for building the docs
# Give the build user rw access to everything in the build directory neccessary for the ASF 'website'.
WORKDIR ${BUILD_DIR}

# install entr
RUN sh -c '\
  set -ex ;\
  ENTR_VERSION="5.8" ;\
  ENTR_SHAS="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" ;\
  wget -q https://github.com/eradman/entr/archive/${ENTR_VERSION}.tar.gz --no-check-certificate ;\
  ENTR_SHA="$(sha256sum ${NODE_TAR} | cut -d" " -f1)" ;\
  echo "$ENTR_SHAS" | sed "s/ /\n/g" | grep -q "$ENTR_SHA" || { echo "SHA256 mismatch for ${ENTR_VERSION}.tar.gz ${ENTR_SHA}"; exit 1; } ;\
  mkdir entr ;\
  tar -C ${BUILD_DIR}/entr --strip-components 1 -xzf ${ENTR_VERSION}.tar.gz ;\
  rm ${ENTR_VERSION}.tar.gz'

WORKDIR ${BUILD_DIR}/entr
RUN ./configure && \
    make CC=gcc && \
    make test && \
    make install

WORKDIR ${BUILD_DIR}
RUN mkdir -p ${BUILD_DIR}/cassandra-website && \
    mkdir -p ${BUILD_DIR}/cassandra && \
    chmod -R a+rw ${BUILD_DIR} && \
    chown -R ${BUILD_USER}:${BUILD_USER} ${BUILD_DIR}

# Set defaults for site build environment variables.
ENV GIT_EMAIL_ADDRESS="${BUILD_USER}@apache.org"
ENV GIT_USER_NAME="${BUILD_USER}"

ENV ANTORA_SITE_TITLE="Apache Cassandra Documentation"
ENV ANTORA_SITE_URL="/"
ENV ANTORA_SITE_START_PAGE="_"

# Build from 3.11.5 as document generation for previous versions is broken.
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_URL="https://github.com/apache/cassandra.git"
# changing the next line also needs updates to the move_intree_document_directories calls in prepare_site_html_for_publication in docker-entrypoint.sh
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_BRANCHES="trunk cassandra-5.0 cassandra-4.1 cassandra-4.0 cassandra-3.11"

ENV ANTORA_CONTENT_SOURCES_CASSANDRA_START_PATH="doc"

ENV ANTORA_CONTENT_SOURCES_CASSANDRA_WEBSITE_URL="https://github.com/apache/cassandra-website.git"
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_WEBSITE_BRANCHES="HEAD"
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_WEBSITE_TAGS=""
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_WEBSITE_START_PATH="site-content/source"

ENV ANTORA_UI_BUNDLE_URL="https://github.com/apache/cassandra-website/raw/trunk/site-ui/build/ui-bundle.zip"

ENV CASSANDRA_DOWNLOADS_URL="https://downloads.apache.org/cassandra/"

ENV LOG_LEVEL="INFO"

EXPOSE 5151/tcp

# Run as build user from here
USER ${BUILD_USER}
WORKDIR ${BUILD_DIR}
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

# Possible commands are listed below. The entrypoint will accept any combination of these commands.
#
#   generate-docs   - Generate Cassandra documentation using Antora
#   build-site      - Build site using Antora
#   preview         - Run container in preview mode where Antora is called to regenerate the site everytime content files are changed
#
# By default we will only generate the docs and build the site.
CMD ["generate-docs","build-site"]
