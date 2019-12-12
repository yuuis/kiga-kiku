FROM ruby:2.5.1

ENV LANG C.UTF-8

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs mariadb-server cron

WORKDIR /kiku

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler && bundle install --clean

COPY batch/cron.conf batch/cron.conf

RUN crontab batch/cron.conf

RUN mkdir -p tmp/sockets
