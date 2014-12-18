FROM ubuntu:14.04
MAINTAINER Arnau Siches <arnau@ustwo.com>

ENV DEBIAN_FRONTEND noninteractive
ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.5
ENV RUBY_SRC_DIR /usr/src/ruby

RUN apt-get update -qqy \
  && apt-get install -qqy \
    curl \
    procps \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qqy \
  && apt-get install -qqy \
    autoconf \
    bison \
    gcc \
    libncurses5-dev \
    libreadline-dev \
    libssl-dev \
    make \
    openssl \
    ruby \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p $RUBY_SRC_DIR \
  && curl -s -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
    | tar -xjC $RUBY_SRC_DIR --strip-components=1

WORKDIR $RUBY_SRC_DIR

RUN autoconf \
  && ./configure \
    --disable-install-doc \
  && make -j"$(nproc)" \
  && apt-get purge -qqy --auto-remove bison ruby \
  && make install \
  && rm -r /usr/src/ruby

CMD ["irb"]
