FROM ubuntu:22.04
#
# Set up non-root user, 'build', with default uid:gid
# This allows passing --build-arg to use localhost username, and uid:gid:
#   $ docker build \
#       -t cassandra-website-ui:latest \
#       --build-arg BUILD_USER_ARG=$(whoami) \
#       --build-arg UID_ARG=$(id -u) \
#       --build-arg GID_ARG=$(id -g) \
#       .
#
# Other container parameters can be overridden at build time as well:
#  - NODE_VERSION_ARG:              Version of node to use.
#
ARG BUILD_USER_ARG="build"
ARG UID_ARG=1000
ARG GID_ARG=1000
ARG NODE_VERSION_ARG="v24.8.0"

ENV BUILD_USER=${BUILD_USER_ARG}

RUN echo "Building with arguments:" \
    && echo " - BUILD_USER_ARG=${BUILD_USER_ARG}" \
    && echo " - UID_ARG=${UID_ARG}" \
    && echo " - GID_ARG=${GID_ARG}" \
    && echo " - NODE_VERSION_ARG=${NODE_VERSION_ARG}"

RUN echo "Setting up user '${BUILD_USER}'"
RUN groupadd --gid ${GID_ARG} --non-unique ${BUILD_USER}
RUN useradd --create-home --shell /bin/bash \
    --uid ${UID_ARG} --gid ${GID_ARG} --non-unique ${BUILD_USER}

RUN apt-get update && \
    apt-get install -y \
        wget \
        git \
        vim

# Install Node.js with architecture detection
RUN sh -c '\
  set -ex ;\
  NODE_PLATFORM=x64 ;\
  [ $(uname -m) = "aarch64" ] && NODE_PLATFORM=arm64 ;\
  NODE_TAR="node-${NODE_VERSION_ARG}-linux-${NODE_PLATFORM}.tar.gz" ;\
  wget -q "https://nodejs.org/download/release/${NODE_VERSION_ARG}/${NODE_TAR}" --no-check-certificate ;\
  tar -xzf "${NODE_TAR}" -C /usr/local --strip-components=1 ;\
  rm "${NODE_TAR}" ;\
  ln -s /usr/local/bin/node /usr/local/bin/nodejs'

RUN npm install -g npm@11.6.0
RUN npm install -g gulp-cli@3.1.0

ENV BUILD_DIR="/home/${BUILD_USER}"
WORKDIR ${BUILD_DIR}
RUN mkdir -p ${BUILD_DIR}/site-ui && \
    chmod -R a+rw ${BUILD_DIR} && \
    chown -R ${BUILD_USER}:${BUILD_USER} ${BUILD_DIR}

EXPOSE 5252/tcp

# Run as build user from here
USER ${BUILD_USER}
WORKDIR ${BUILD_DIR}/site-ui
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["--tasks", "--depth", "1"]