FROM ubuntu:12.04
MAINTAINER korvinca@gmail.com

RUN echo "America/Los_Angeles" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN apt-get update && \
    apt-get install -y nano \
    apache2 \
    apache2-mpm-itk \
    php5 \
    php5-apc \
    php-pear \
    php5-dev \
    php5-gd \
    mysql-client \
    php5-mysql \
    php5-curl \
    php5-json \
    php5-cli \
    php5-mcrypt \
    php5-gd \
    postfix

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

#COPY default_old /etc/apache2/sites-available/default_old
COPY run.sh /usr/local/bin/run.sh
COPY reload /usr/local/bin/reload
RUN chmod +x /usr/local/bin/*
ADD conf /etc/apache2/

RUN apt-get install -y libapache2-mod-rpaf \
    a2enmod rewrite \
    a2enmod headers \
    a2enmod rpaf \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

VOLUME /var/www /etc/apache2/sites-enabled /var/log/apache2

CMD ["/usr/local/bin/run.sh"]
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
