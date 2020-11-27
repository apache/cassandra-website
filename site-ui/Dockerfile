FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        wget \
        git \
        vim

ARG NODE_VERSION="v12.16.2"
ENV NODE_PACKAGE="node-${NODE_VERSION}-linux-x64.tar.gz"
RUN wget https://nodejs.org/download/release/${NODE_VERSION}/${NODE_PACKAGE} && \
    tar -C /usr/local --strip-components 1 -xzf ${NODE_PACKAGE} && \
    rm ${NODE_PACKAGE}

RUN npm install -g gulp-cli

ENV BUILD_DIR="/home/site-ui"

RUN mkdir -p ${BUILD_DIR}

EXPOSE 5252/tcp

WORKDIR ${BUILD_DIR}
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["--tasks", "--depth", "1"]