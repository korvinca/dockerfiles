#!/bin/bash
set -es

# PHP
PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-"E_ALL & ~E_DEPRECATED & ~E_NOTICE"}
sed -ri 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Los_Angeles/g' /etc/php5/cli/php.ini
sed -ri 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Los_Angeles/g' /etc/php5/apache2/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini
sed -ri 's/^open_basedir\s*=\s*Off/open_basedir none/g' /etc/php5/cli/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/apache2/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/cli/php.ini
sed -ri 's/post_max_size = 8M/post_max_size = 50M/g' /etc/php5/apache2/php.ini
sed -ri 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php5/apache2/php.ini

# setup php/sendmail
sed -ri 's/;sendmail_path =/sendmail_path = /usr/sbin/sendmail -t -i/g' /etc/php5/apache2/php.ini
sed -ri 's/;mail.force_extra_parameters =/mail.force_extra_parameters = -fdo_not_reply@korolevskiy.com/g' /etc/php5/apache2/php.ini

echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/apache2/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/cli/php.ini

# sendmail to send email via PHP
line=$(head -n 1 /etc/hosts)
line2=$(echo $line | awk '{print $2}')
echo "$line $line2.localdomain" >> /etc/hosts
/etc/init.d/sendmail start

#Apache2
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP $APACHE_LOG_DIR
echo "ServerName localhost" >> /etc/apache2/httpd.conf
source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
