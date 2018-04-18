# WORK IN PROGRESS
Use at your own risk.
# Letsencrypt
When using letsencrypt, specify an EMAIL address to your desired TRUSTED_DOMAIN for letsencryp, then run:

```
docker exec -it nextcloud_web_1 bash -c 'letsencrypt --apache --non-interactive --agree-tos --email $EMAIL --domains $TRUSTED_DOMAIN'
```

Also, add a cronjob to run the following command:
```
30 6,15 * * * root docker exec nextcloud_web_1 letsencrypt renew --agree-tos
```

