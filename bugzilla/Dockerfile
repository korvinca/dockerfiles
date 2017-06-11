FROM ubuntu
MAINTAINER KorvinCA <korvinca@mgail.com>

ENV BUGZILLA bugzilla-4.4.12
ENV BUGZILLA_TAR $BUGZILLA.tar.gz
ENV BUGZILLA_URL http://ftp.mozilla.org/pub/mozilla.org/webtools/$BUGZILLA_TAR
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y nano \
    curl \
    apache2 \
    make \
    gcc \
    g++ \
	libxml2-dev \
	libgd-dev \
	libdbd-mysql-perl \
	libapache2-mod-perl2 \
	sendmail && \
	a2enmod rewrite headers expires cgi

# Insatll MYSQL
RUN echo 'mysql-server mysql-server/root_password password passss' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password passss' | debconf-set-selections && \
    apt-get install -y mysql-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Install Bugzilla
RUN curl --silent --output "/tmp/$BUGZILLA_TAR" "$BUGZILLA_URL"
RUN tar xzvf "/tmp/$BUGZILLA_TAR" --directory /opt/
RUN cd /opt/ && ln -s "$BUGZILLA" bugzilla
WORKDIR /opt/bugzilla
RUN ./install-module.pl --all
RUN ./checksetup.pl

# Add start script
COPY start.sh /opt/
RUN chmod +x /opt/start.sh

EXPOSE 80

CMD ["/opt/start.sh"]
