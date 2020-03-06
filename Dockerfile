FROM debian:stretch

# Set up non-root user, 'build', with default uid:gid
# This allows passing --build-arg to use local host user's uid:gid:
#   $ docker-compose build \
#     --build-arg UID=$(id -u) \
#     --build-arg GID=$(id -g) \
#     cassandra-website
ARG UID=1000
ARG GID=1000
RUN echo "Setting up user 'build' with UID=${UID} GID=${GID}"
RUN groupadd --gid $GID --non-unique build
RUN useradd --create-home --shell /bin/bash \
    --uid $UID --gid $GID --non-unique build

# Install tools
RUN apt-get update && \
    apt-get install -y \
        openjdk-8-jdk \
        procps \
        git \
        python2.7 \
        python-pip \
        ruby-full \
        make \
        ant \
        ant-optional \
        maven

# Install Sphinx for generating Cassandra docs
RUN pip install --no-cache-dir \
        sphinx \
        sphinx_rtd_theme

COPY ./src/Gemfile /
COPY ./src/Gemfile.lock /

RUN gem install bundler && \
    bundle install && \
    rm /Gemfile /Gemfile.lock

# Run as build user from here
USER build

ENV CASSANDRA_DIR="/home/build/cassandra"

# Setup repositories to building the docs
RUN mkdir -p /home/build/cassandra-site && \
    git clone https://gitbox.apache.org/repos/asf/cassandra.git ${CASSANDRA_DIR}

EXPOSE 4000/tcp

COPY docker-entrypoint.sh /home/build/
ENTRYPOINT ["/home/build/docker-entrypoint.sh"]

CMD [""]
