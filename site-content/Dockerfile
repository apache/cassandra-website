FROM ubuntu:22.04

# Set up non-root user, 'build', with default uid:gid
# This allows passing --build-arg to use localhost username, and uid:gid:
#   $ docker build \
#       -t cassandra-website:latest \
#       --build-arg BUILD_USER_ARG=$(whoami) \
#       --build-arg UID_ARG=$(id -u) \
#       --build-arg GID_ARG=$(id -g) \
#       .
#
# Other container parameters can be overridden at build time as well:
#  - NODE_VERSION_ARG:              Version of node to use.
#  - ENTR_VERSION_ARG:              Version of entr to use.
#
#
# For developer convenience (to avoid having to run `./run.sh website container`) publish trunk changes to dockerhub with:
# `docker buildx build --platform linux/amd64,linux/arm64 -f ./site-content/Dockerfile -t apache/cassandra-website:latest --provenance=true --sbom=true --push  ./site-content/`
#
ARG BUILD_USER_ARG="build"
ARG UID_ARG=1000
ARG GID_ARG=1000
ARG NODE_VERSION_ARG="v20.16.0"
ARG ENTR_VERSION_ARG="4.6"
ARG TARGETPLATFORM

# GO_VERSION_SHAS must contain contain a matching sha256 for the $GO_VERSION download.  there should only be four SHAs listed.
ARG GO_VERSION="1.24.3"
ARG GO_VERSION_SHAS="3333f6ea53afa971e9078895eaa4ac7204a8c6b5c68c10e6bc9a33e8e391bdd8 a463cb59382bd7ae7d8f4c68846e73c4d589f223c589ac76871b66811ded7836 13e6fe3fcf65689d77d40e633de1e31c6febbdbcb846eb05fc2434ed2213e92b 64a3fa22142f627e78fac3018ce3d4aeace68b743eff0afda8aae0411df5e4fb"

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
        openjdk-8-jdk \
        openjdk-11-jdk \
        openjdk-17-jdk \
        python3 \
        python3-pip \
        ant \
        ant-optional \
        make \
        git \
        gpg \
        wget \
        curl \
        gcc \
        sudo

# install golang.  GO_VERSION_SHA must be updated with VERSION
RUN sh -c '\
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

# INSTALL nodejs and nvm
RUN export PLATFORM=$(if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then echo "x64"; else echo "arm64"; fi) \
  && set -ex \
  && wget "https://nodejs.org/dist/$NODE_VERSION_ARG/node-$NODE_VERSION_ARG-linux-$PLATFORM.tar.xz" \
  && tar -xJf "node-$NODE_VERSION_ARG-linux-$PLATFORM.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-$NODE_VERSION_ARG-linux-$PLATFORM.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

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
ENV ENTR_PACKAGE="${ENTR_VERSION_ARG}.tar.gz"
WORKDIR ${BUILD_DIR}
RUN wget https://github.com/eradman/entr/archive/${ENTR_PACKAGE} --no-check-certificate && \
    mkdir entr && \
    tar -C ${BUILD_DIR}/entr --strip-components 1 -xzf ${ENTR_PACKAGE} && \
    rm ${ENTR_PACKAGE}

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
# FIXME – we can't generate tags yet as in-tree doc/antora.yml doesn't specify specifc tag versions
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_TAGS=""
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
