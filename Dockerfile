FROM ubuntu:18.04
# Set up non-root user, 'build', with default uid:gid
# This allows passing --build-arg to use local host user's uid:gid:
#   $ docker build \
#       -t cassandra-website:latest \
#       --build-arg UID=$(id -u) \
#       --build-arg GID=$(id -g) \
#       .
#
# Other container parameters can be overridden at build time as well:
#  - BUILD_USER:            Name of the user to run as when building the docs and site.
#  - NODE_VERSION:          Version of node to use.
#  - CASSANDRA_GIT_URL:     Git URL to use for the Cassandra repository.
ARG UID=1000
ARG GID=1000
ARG BUILD_USER=build
ARG NODE_VERSION="v12.16.2"
ARG CASSANDRA_GIT_URL="https://gitbox.apache.org/repos/asf/cassandra.git"

RUN echo "Setting up user 'build' with UID=${UID} GID=${GID}"
RUN groupadd --gid ${GID} --non-unique ${BUILD_USER}
RUN useradd --create-home --shell /bin/bash \
    --uid ${UID} --gid ${GID} --non-unique ${BUILD_USER}
# INSTALL wget, python3, java11, and other tools required to build the docs
RUN apt-get update && \
    apt-get install -y \
        wget \
        gpg \
        python3 \
        python3-pip \
        openjdk-11-jdk \
        git \
        make \
        ant \
        ant-optional

RUN pip3 install jinja2

# INSTALL nodejs and nvm
ENV NODE_PACKAGE="node-${NODE_VERSION}-linux-x64.tar.gz"
RUN wget https://nodejs.org/download/release/${NODE_VERSION}/${NODE_PACKAGE} && \
    tar -C /usr/local --strip-components 1 -xzf ${NODE_PACKAGE} && \
    rm ${NODE_PACKAGE}

# Use npm to install Antora globally
# and antora-lunr for site search
RUN npm i -g @antora/cli@2.3 @antora/site-generator-default@2.3
RUN npm i -g antora-lunr antora-site-generator-lunr

ENV BUILD_DIR="/home/${BUILD_USER}"

ENV GIT_EMAIL_ADDRESS ""
ENV GIT_USER_NAME ""

#ENV BUILD_MODE "preview"
#ENV GPG_KEY_PATH ""
#ENV GENERATE_NODETOOL_AND_CONFIG_DOCS "true"
#ENV WEB_SERVER_PORT "5000"

# Set defaults for site build variables.
# Build from 3.11.5 as document generation for previous versions is broken.
ENV CASSANDRA_REPOSITORY_URL "${CASSANDRA_GIT_URL}"
ENV CASSANDRA_VERSIONS="trunk cassandra-4.0 cassandra-3.11.8 cassandra-3.11.7 cassandra-3.11.6 cassandra-3.11.5"
ENV CASSANDRA_START_PATH="doc/sourc"
ENV CASSANDRA_WEBSITE_REPOSITORY_URL="https://gitbox.apache.org/repos/asf/cassandra-website.git"
ENV CASSANDRA_WEBSITE_VERSIONS="trunk"
ENV CASSANDRA_WEBSITE_START_PATH="site-content/source"

# Setup directories for building the docs
#  Give the build user rw access to everything in the build directory,
#   neccessary for the ASF 'websites' jenkins agent (which can't chown)
RUN mkdir -p ${BUILD_DIR}/cassandra-site && \
    git clone ${CASSANDRA_GIT_URL} ${BUILD_DIR}/cassandra && \
    mkdir -p ${BUILD_DIR}/cassandra/doc/build_gen && \
    chmod -R a+rw ${BUILD_DIR}

#EXPOSE ${WEB_SERVER_PORT}/tcp

# Run as build user from here
USER ${BUILD_USER}
WORKDIR ${BUILD_DIR}
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD [""]
