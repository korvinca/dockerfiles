#!/bin/bash
set -es

# PHP
PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-"E_ALL & ~E_DEPRECATED & ~E_NOTICE"}
sed -ri 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Los_Angeles/g' /etc/php5/cli/php.ini
sed -ri 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Los_Angeles/g' /etc/php5/apache2/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = Off/g' /etc/php5/apache2/php.ini
sed -ri 's/^open_basedir\s*=\s*Off/open_basedir none/g' /etc/php5/cli/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/apache2/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/cli/php.ini
sed -ri 's/post_max_size = 8M/post_max_size = 70M/g' /etc/php5/apache2/php.ini
sed -ri 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php5/apache2/php.ini

# New
sed -ri 's/;session.save_path = "/tmp"/session.save_path = "/var/lib/php5"/g' /etc/php5/apache2/php.ini
sed -ri 's/;sendmail_path =/sendmail_path = /usr/sbin/sendmail -t -i -fno-reply@korolevskiy.com/g' /etc/php5/apache2/php.ini
sed -ri 's/mail.add_x_header = On/mail.add_x_header = Off/g' /etc/php5/apache2/php.ini

# Errors for Jommla 1.5
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/apache2/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/cli/php.ini

# APC
echo "; configuration for php apc module" >> /etc/php5/apache2/php.ini
echo "extension=apc.so" >> /etc/php5/apache2/php.ini
echo "apc.enabled = On" >> /etc/php5/apache2/php.ini
echo "apc.shm_size = 128M" >> /etc/php5/apache2/php.ini
echo "apc.max_file_size = 4M" >> /etc/php5/apache2/php.ini
echo "apc.num_files_hint = 2048" >> /etc/php5/apache2/php.ini
echo "apc.file_update_protection = 3" >> /etc/php5/apache2/php.ini

# Postfix
mkfifo /var/spool/postfix/public/pickup
ps aux | grep mail kill /etc/init.d/postfix restart

#Apache2
sed -ri 's/KeepAlive On/KeepAlive Off/g' /etc/apache2/apache2.conf
sed -ri 's/Timeout 300/Timeout 310/g' /etc/apache2/apache2.conf
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP $APACHE_LOG_DIR

source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
