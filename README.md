# Nextcloud as a Docker Container

## DEPRECATION NOTICE

This repository has been deprecated in favor of the official Nextcloud Docker Image found at: https://github.com/nextcloud/docker

It is now read only and will no longer be updated.

## Description

This docker image contains Nextcloud packaged with Apache2 HTTPD.
The docker-compose file provisions Nextcloud, MySQL and Redis.

## Requirements

* Docker
* Docker Compose

## Usage

Adjust `docker-compose.yml` to your liking (be sure to update the passwords!):

```bash
vim docker-compose.yml
```

Set permissions to secure your passwords:

```bash
chmod 600
```

and then run:

```bash
docker-compose up -d
```

## Variables

### Nextcloud

* `ADMIN_USER`

```bash
ADMIN_USER: admin
```

The username for the initial admin user, created on a new installation.

* `ADMIN_PASSWORD`

```bash
ADMIN_PASSWORD: admin
```

The password for the initial admin user, created on a new installation.

* `TRUSTED_DOMAIN`

```bash
TRUSTED_DOMAIN: localhost
```

The trusted domain that is used by Nextcloud to determine if access is granted, as well as by Let's Encrypt, if you want to use it.

### MySQL

* `MYSQL_ROOT_PASSWORD`

```bash
MYSQL_ROOT_PASSWORD: nextcloud
```

The password of the user `root` in the database.

* `MYSQL_USER`

```bash
MYSQL_USER: nextcloud
```

The user used to connect to the database.

* `MYSQL_PASSWORD`

```bash
MYSQL_PASSWORD: nextcloud
```

The password used to connect to the database.

## Enable Letsencrypt

Use Traefk as a frontend to enable Let's Encrypt.

## Enable Cron

If you want to use cronjobs inside Nextcloud, setup a job like this:

```cron
*/15  *  *  *  * docker exec $(docker ps | grep nextcloud_web | awk '{print $NF}') sh -c "sudo -u www-data php -f /var/www/html/nextcloud/cron.php"
```

# License

Licensed under the MIT License, see LICENSE for more details.
