Nextcloud as a Docker Container
==============================

# Description
This docker image contains Nextcloud packaged with Apache2 HTTPD.
The docker-compose file provisions Nextcloud, MySQL and Redis.

# Requirements
* Docker
* Docker Compose

# Usage
Adjust `docker-compose.yml` to your liking (be sure to update the passwords!):
```
vim docker-compose.yml
```

Set permissions to secure your passwords:
```
chmod 600
```

and then run:
```
docker-compose up -d
```

## Variables

### Nextcloud

* `ADMIN_USER`
```
ADMIN_USER: admin
```
The username for the initial admin user, created on a new installation.

* `ADMIN_PASSWORD`
```
ADMIN_PASSWORD: admin
```
The password for the initial admin user, created on a new installation.

* `TRUSTED_DOMAIN`
```
TRUSTED_DOMAIN: localhost
```
The trusted domain that is used by Nextcloud to determine if access is granted, as well as by Let's Encrypt, if you want to use it.

* `EMAIL`
```
EMAIL: noreply@example.com
```
The email address used by Let's Encrypt to generate a new certificate.

### MySQL

* `MYSQL_ROOT_PASSWORD`
```
MYSQL_ROOT_PASSWORD: nextcloud
```
The password of the user `root` in the database.

* `MYSQL_USER`
```
MYSQL_USER: nextcloud
```
The user used to connect to the database.

* `MYSQL_PASSWORD`
```
MYSQL_PASSWORD: nextcloud
```
The password used to connect to the database.

# Enable Letsencrypt
When using letsencrypt, specify an EMAIL address to your desired TRUSTED_DOMAIN for letsencryp, then run:

```
docker exec -it nextcloud_web_1 bash -c 'certbot run --apache --non-interactive --agree-tos --email $EMAIL --domains $TRUSTED_DOMAIN'
```

Also, add a cronjob to run the following command:
```
30 6,15 * * * root docker exec nextcloud_web_1 certbot renew --agree-tos
```

# License
Licensed under the MIT License, see LICENSE for more details.
