FROM ubuntu:12.04
MAINTAINER korvinca@gmail.com

RUN echo "America/Los_Angeles" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN apt-get update \
    && apt-get install -q -y language-pack-en \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get install -y apache2 \
    && a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

#COPY default /etc/apache2/sites-available/default
COPY run.sh /usr/local/bin/run.sh
COPY reload /usr/local/bin/reload
RUN chmod +x /usr/local/bin/*

RUN apt-get install -y php5 \
    libapache2-mod-php5 \
    php5-mysql \
    php5-curl \
    php5-json \
    php5-cli \
    php5-mcrypt \
    php5-gd

# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string  Satellite system" > preseed.txt \
    && echo "postfix postfix/mailname string host.korolevskiy.com" >> preseed.txt \
    && debconf-set-selections preseed.txt \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

VOLUME /var/www /etc/apache2/sites-enabled /var/log/apache2

CMD ["sh", "-c", "service postfix start; /usr/local/bin/run.sh"]
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
