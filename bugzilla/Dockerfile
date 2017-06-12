FROM ubuntu:16.04
MAINTAINER KorvinCA <korvinca@mgail.com>

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y apache2 \
    nano \
    curl \
    make \
    gcc \
    g++ \
  	libxml2-dev \
    libgd-dev \
    libdbd-mysql-perl \
	  libapache2-mod-perl2 \
	  msmtp && \
	  a2enmod rewrite headers expires cgi

# Install MYSQL
RUN echo 'mysql-server mysql-server/root_password password passss' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password passss' | debconf-set-selections && \
    apt-get install -y mysql-server && \
	  apt-get clean && \
	  rm -rf /var/lib/apt/lists/*

# Install Bugzilla
ENV BUGZILLA bugzilla-4.4.12
ENV BUGZILLA_TAR $BUGZILLA.tar.gz
ENV BUGZILLA_URL http://ftp.mozilla.org/pub/mozilla.org/webtools/$BUGZILLA_TAR
ENV DEFAULT_MYSQL_HOST localhost
ENV DEFAULT_MYSQL_PORT 0
ENV DEFAULT_MYSQL_DB bugs
ENV DEFAULT_MYSQL_USER root
ENV DEFAULT_MYSQL_PWD passss

RUN curl --silent --output "/tmp/$BUGZILLA_TAR" "$BUGZILLA_URL" && \
  tar xzvf "/tmp/$BUGZILLA_TAR" --directory /opt/ && \
  rm -rf "/tmp/$BUGZILLA_TAR" && \
  cd /opt/ && \
  ln -s "$BUGZILLA" bugzilla

# Update the default apache site with the config we created.
ADD bugzilla.conf /etc/apache2/sites-enabled/000-default.conf

# Add start script
#COPY start.sh /usr/local/bin/start.sh
COPY bugzilla_admin /opt/bugzilla/bugzilla_admin
COPY msmtprc /etc/msmtprc
#RUN chmod +x /usr/local/bin/*

# Apache2
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

# Substitute values into bugzilla localconfig
WORKDIR /opt/bugzilla

RUN ./install-module.pl --all && \
  ./checksetup.pl && \
  sed -ri 's/create_htaccess *= *[0-9.]\+/create_htaccess = 0;/g' ./localconfig && \
  sed -ri 's/webservergroup *= *'[a-zA-Z0-9]\+'/webservergroup = 'www-data'/g' ./localconfig && \
  sed -ri 's/db_host *= *'[a-zA-Z0-9.]\+'/db_host = '${MYSQL_HOST:-$DEFAULT_MYSQL_HOST}'/g' ./localconfig && \
  sed -ri 's/db_port *= *[0-9.]\+/db_port = ${MYSQL_PORT:-$DEFAULT_MYSQL_PORT}/g' ./localconfig && \
  sed -ri 's/db_name *= *'[a-zA-Z0-9.]\+'/db_name = '${MYSQL_DB:-$DEFAULT_MYSQL_DB}'/g' ./localconfig && \
  sed -ri 's/db_user *= *'[a-zA-Z0-9.]\+'/db_user = '${MYSQL_USER:-$DEFAULT_MYSQL_USER}'/g' ./localconfig && \
  sed -ri 's/db_pass\s*=\s*'[^']*'/db_pass = 'passss'/g' ./localconfig && \
  ./checksetup.pl bugzilla_admin

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
