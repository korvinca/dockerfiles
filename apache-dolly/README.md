# docker-apache2-PHP5.3

apache2, php5.3

# Overview

This image is based on ubuntu:12.04.
Apache, PHP5.3

Avaliable php5 modules are php5-gd, php5-mysql, php5-curl, php5-json, php5-mcrypt.

Apache listen on port 80.
Web application is placed in /var/www/

# For test apache (make changes in default): 

docker run -d -p 80:80 -v /var/www/:/var/www  apache

# For reloadt apache after changes in virtual_host config: 

docker exec -ti apache reload

# Usede web sites

http://www.site.com
