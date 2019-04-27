FROM ruby:2.5.1

ENV LANG C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs mariadb-server

WORKDIR /kiku

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler && bundle install --clean

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ADD . /kiku

RUN mkdir -p tmp/sockets
