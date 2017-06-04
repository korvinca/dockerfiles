FROM ubuntu:12.04
MAINTAINER korvinca@gmail.com

RUN echo "America/Los_Angeles" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && \
  apt-get install -y mysql-client && apt-get clean && \
  rm -rf /var/lib/apt/lists/*
