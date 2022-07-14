FROM ubuntu:18.04
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
ARG BUILD_USER_ARG="build"
ARG UID_ARG=1000
ARG GID_ARG=1000
ARG NODE_VERSION_ARG="v12.16.2"
ARG ENTR_VERSION_ARG="4.6"

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
        python3 \
        python3-pip \
        ant \
        ant-optional \
        make \
        git \
        gpg \
        wget \
        sudo

RUN pip3 install jinja2 requests

# INSTALL nodejs and nvm
ENV NODE_PACKAGE="node-${NODE_VERSION_ARG}-linux-x64.tar.gz"
RUN wget https://nodejs.org/download/release/${NODE_VERSION_ARG}/${NODE_PACKAGE} && \
    tar -C /usr/local --strip-components 1 -xzf ${NODE_PACKAGE} && \
    rm ${NODE_PACKAGE}

# Use npm to install Antora globally, and antora-lunr for site search, and js-yaml to load YAML files
RUN npm i -g @antora/cli@2.3 @antora/site-generator-default@2.3 @djencks/asciidoctor-openblock
RUN npm i -g antora-lunr antora-site-generator-lunr
RUN npm i -g live-server

# Create the build user and make it part of the password-less sudo group
ENV BUILD_USER=${BUILD_USER_ARG}
RUN groupadd --gid ${GID_ARG} --non-unique ${BUILD_USER} && \
    useradd --create-home --shell /bin/bash --uid ${UID_ARG} --gid ${GID_ARG} --non-unique ${BUILD_USER} && \
    usermod -aG sudo ${BUILD_USER} && \
    sed -i 's/\(^%sudo\tALL=(ALL:ALL)\).*/\1 NOPASSWD:ALL/g' /etc/sudoers

# Setup directories for building the docs
# Give the build user rw access to everything in the build directory neccessary for the ASF 'website'.
ENV BUILD_DIR="/home/${BUILD_USER}"
ENV ENTR_PACKAGE="${ENTR_VERSION_ARG}.tar.gz"
WORKDIR ${BUILD_DIR}
RUN wget https://github.com/eradman/entr/archive/${ENTR_PACKAGE} && \
    mkdir entr && \
    tar -C ${BUILD_DIR}/entr --strip-components 1 -xzf ${ENTR_PACKAGE} && \
    rm ${ENTR_PACKAGE}

WORKDIR ${BUILD_DIR}/entr
RUN ./configure && \
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
ENV ANTORA_CONTENT_SOURCES_CASSANDRA_BRANCHES="trunk cassandra-4.1 cassandra-4.0 cassandra-3.11"
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
