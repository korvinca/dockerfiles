#!/bin/sh
# Set up bugzilla and run apache2
set -e

DEFAULT_MYSQL_HOST=localhost
DEFAULT_MYSQL_PORT=0
DEFAULT_MYSQL_DB=bugs
DEFAULT_MYSQL_USER=root
DEFAULT_MYSQL_PWD=passss

# cd /opt/bugzilla

# Substitute values into bugzilla localconfig
#sed --in-place "s/webservergroup *= *'[a-zA-Z0-9]\+'/webservergroup = 'www-data'/" localconfig
#sed --in-place -f - localconfig <<SED
#s/db_host *= *'[a-zA-Z0-9.]\+'/db_host = '${MYSQL_HOST:-$DEFAULT_MYSQL_HOST}'/
#s/db_port *= *[0-9.]\+/db_port = ${MYSQL_PORT:-$DEFAULT_MYSQL_PORT}/
#s/db_name *= *'[a-zA-Z0-9.]\+'/db_name = '${MYSQL_DB:-$DEFAULT_MYSQL_DB}'/
#s/db_user *= *'[a-zA-Z0-9.]\+'/db_user = '${MYSQL_USER:-$DEFAULT_MYSQL_USER}'/
#s/db_pass\s*=\s*'[^']*'/db_pass = 'passss'/
#SED

#service mysql restart

# Verify bugzilla setup
#./checksetup.pl

# sendmail to send email via PHP
#line=$(head -n 1 /etc/hosts)
#line2=$(echo $line | awk '{print $2}')
#echo "$line $line2.localdomain" >> /etc/hosts
#/etc/init.d/sendmail start

# Apache2
echo "ServerName localhost" >> /etc/apache2/httpd.conf
source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
