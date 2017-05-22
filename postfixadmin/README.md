# About this image (Marc Richter)

![postfixadmin](http://i.imgur.com/UCtvKHR.png "postfixadmin")

Postfix Admin is a web based interface used to manage mailboxes, virtual domains and aliases. It also features support for vacation/out-of-the-office messages.

This work is heavily based on [hardware/postfixadmin](https://github.com/hardware/postfixadmin). Most is 1:1 identically and most of the credits for this image go to [hardware](https://github.com/hardware), exceptionally the following differences (as of the time of this writing):

- There was no scripting hook in the startup process which made it possible to change anything in the startup process. This image supports that.
- There was no way to keep local config for Postfix Admin during container restarts. This image offers a way to save the config during restarts.
- Postfix Admin source was taken from a ``tar.gz`` file and thus hard coded to a specific version. This now comes from SVN, is ``trunk`` by default and can be changed to a [tag](http://svn.code.sf.net/p/postfixadmin/code/tags/) you desire.
- [Supervisor](http://supervisord.org/) is used in the original image, but configured and started in a way, which breaks some of it's features (like using ``supervisorctl``). This is fixed in this image.
- This image supports both, MySQL and PostgreSQL databases.

### Requirements

- Docker 1.0 or higher
- Separate MySQL or PostgreSQL server

### How to start a container

You can start a container of this image with the following command:

```
docker run -d \
  --name postfixadmin
  -p 80:80 \
  -e DBPASS=xxxxxxxx \
  -h mail.domain.tld \
  korvinca/postfixadmin
```

- ``--name postfixadmin``: "*postfixadmin*" can be anything you like to make it easy for you to identify the container in Docker's list of containers and to refer to it in your setups and scripts.
- ``-p 80:80`` opens port 80 (default for HTTP) on all IPs of your Docker-Host. If that socket is already in use, you can limit this to a specific IP only; refer to [Docker's official docs](https://docs.docker.com/engine/reference/run/#expose-incoming-ports) for more detail. If you plan to add a reverse proxy to your setup, you most probably want to not use ``-p`` at all.
- ``-e DBPASS=xxxxxxxx``: "*xxxxxxxx*" must be replaced by the password for the DB-user, set by the variable ``DBUSER`` (defaults to ``postfix``).
- ``-h mail.domain.tld``: This should be set to the FQDN of your Postfix Server.

**Note:** This image does not ship with a RDBS (MySQL or PostgreSQL). You will have to setup one on your own and make sure both, this container and your Postfix/IMAP-Daemons have access to.

There are ways to use docker for this; read about the [linking system](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/#connect-with-the-linking-system) of Docker.

#### Setup

After you gave the container a few seconds to start (usually <10), you should be able to navigate your favorite webbrowser to ``http://ip/setup.php`` (replace *ip* with the FQDN/ip of your server).

The automatic setup script then guides you through the rest of the process

### List of environment variables

- **GID** = postfixadmin user id (*optional*, default: 991)
- **UID** = postfixadmin group id (*optional*, default: 991)
- **DBS** = Database system to use (*optional*, default: mysqli)
- **DBHOST** = Database instance ip/hostname (*optional*, default: dbhost)
- **DBUSER** = Database username (*optional*, default: postfix)
- **DBNAME** = Database name (*optional*, default: postfix)
- **DBPASS** = Database password (**required**)
- **SETUPPASS** = Postfix Admin setup password (*optional*)
- **VERSION** = Postfix Admin version to use. (*optional*, default: trunk)

### Using PostgreSQL instead of MySQL

By default, the Postfix Admin configuration option ``$CONF['database_type']`` is set to the content of the variable ``$DBS``, which is set to ``mysqli`` by default. This results in:

```
$CONF['database_type'] = 'mysqli';
```

When you add this to the Docker commandline:

```
-e DBS=pgsql
```

you set this variable to ``pgsql`` instead, which results in:

```
$CONF['database_type'] = 'pgsql';
```

and uses that PostgreSQL module for DB connections instead.

### Using a different version of Postfix Admin

This image uses Subversion to checkout (download) a copy of Postfix Admin when it is build. It uses the [trunk](http://svn.code.sf.net/p/postfixadmin/code/trunk) for this, which represents the latest version of the code available.

If you want to use another version, you can do so by defining the variable ``$VERSION`` on your Docker commandline, adding:

```
-e VERSION=postfixadmin-x.yy
```

This switches to the specified tag (Subversion) before starting the daemons.
You can use every [tag in the Postfix Admin Subversion tree](http://svn.code.sf.net/p/postfixadmin/code/tags/). For example, if you would like to use version ``3.02`` of Postfix Admin, you would add the following to your Docker commandline:

```
-e VERSION=postfixadmin-3.02
```

### Docker-compose

The following is an example for docker-compose, using MariaDB as DBS:

``Docker-compose.yml``:

```
postfixadmin:
  image: korvinca/postfixadmin
  container_name: postfixadmin
  domainname: domain.tld
  hostname: mail
  links:
    - mariadb:dbhost
  ports:
    - "80:80"
  environment:
    - DBHOST=dbhost
    - DBUSER=postfix
    - DBNAME=postfix
    - DBPASS=xxxxxxx

mariadb:
  image: mariadb:10.1
  volumes:
    - /mnt/docker/mysql/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=xxxx
    - MYSQL_DATABASE=postfix
    - MYSQL_USER=postfix
    - MYSQL_PASSWORD=xxxx
```

Startup:

```
docker-compose up -d
```

### Setup postfixadmin

1 - Go to the setup page : https://postfixadmin.domain.tld/setup.php

:bulb: Don't forget to add a new A/CNAME record in your DNS zone.

2 - Define the setup password

3 - Set the setup hash

docker exec -ti postfixadmin setup

> Postfixadmin setup hash : ffdeb741c58db70d060ddb170af4623a:54e0ac9a55d69c5e53d214c7ad7f1e3df40a3caa
Setup done.

4 - Create admin account

5 - Go to the login page : https://postfixadmin.your-domain.tld/

6 - You can now create your domains, mailboxes, alias...etc
