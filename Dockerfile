FROM debian:stretch

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

ENV CASSANDRA_DIR="/usr/src/cassandra"

# Setup repositories to building the docs
RUN mkdir -p /usr/src/cassandra-site && \
    git clone https://gitbox.apache.org/repos/asf/cassandra.git ${CASSANDRA_DIR}

EXPOSE 4000/tcp

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [""]
