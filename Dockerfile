FROM ruby:3.3 AS base

WORKDIR /opt/app

RUN apt-get update && apt-get -y install bash-completion build-essential vim

COPY Gemfile* . 

RUN if [ -f Gemfile ]; then bundle install; fi

COPY * .

CMD ["ruby"]