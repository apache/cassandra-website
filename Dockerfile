FROM debian:latest

# Install Java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && \
    apt-get install -y \
        software-properties-common \
        gpg && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Install other tools
RUN apt-get update && \
    apt-get install -y \
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
