FROM ubuntu:18.04

ENV TMP_DIR /tmp
ENV RELEASE 16.0.0
ENV HOME /var/www/html/nextcloud
ENV PHP_VERSION 7.2
ENV TERM=xterm
ENV REFRESHED_AT 2019-05-03
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Update system
RUN apt-get update \
		&& apt-get dist-upgrade -y \
		&& apt-get install -y apache2 \
			libapache2-mod-php \
			php-mysql \
			php-curl \
			php-fileinfo \
			php-bz2 \
			php-intl \
			php-exif \
			php-apcu \
			php-redis \
			php-json \
			php-gd \
			php-imagick \
      php-dom \
      php-zip \
      php-xml \
      php-mbstring \
			bzip2 \
      sudo \
			ffmpeg \
      smbclient \
      software-properties-common \
      wget \
      rsync

# Install Certbot
RUN add-apt-repository universe \
  && add-apt-repository ppa:certbot/certbot \
  && apt-get update \
  && apt-get install -y certbot python-certbot-apache 

# Download installation files
WORKDIR $TMP_DIR
RUN wget https://download.nextcloud.com/server/releases/nextcloud-$RELEASE.tar.bz2 \
      && wget -4 https://download.nextcloud.com/server/releases/nextcloud-$RELEASE.tar.bz2.sha256 \
      && wget -4 https://download.nextcloud.com/server/releases/nextcloud-$RELEASE.tar.bz2.asc \
      && wget -4 https://nextcloud.com/nextcloud.asc

# Verify integrity
RUN cd $TMP_DIR \
  && sha256sum -c nextcloud-$RELEASE.tar.bz2.sha256 | grep OK
# && gpg --import nextcloud.asc \
# && gpg --verify nextcloud-$RELEASE.tar.bz2.asc nextcloud-$RELEASE.tar.bz2 | grep "Good signature"

# Install application
RUN cd $TMP_DIR && tar -xjf nextcloud-$RELEASE.tar.bz2 && mv nextcloud $HOME && cp -a $HOME/apps /opt/apps_original

# Install webserver config
COPY nextcloud.conf /etc/apache2/sites-available/nextcloud.conf

# Install php config
COPY php.ini /etc/php/${PHP_VERSION}/apache2/php.ini

# TODO allow all in blocklists overrides htaccess in nextcloud!
# Install blocklist config
#COPY getBlocklists.sh /usr/local/bin/getBlocklists.sh
#RUN chmod a+x /usr/local/bin/getBlocklists.sh && sync && usr/local/bin/getBlocklists.sh

# Configure apache httpd
RUN a2enmod \
      rewrite \
      php"${PHP_VERSION}" \
      headers \
      env \
      dir \
      mime \
      ssl \
      proxy_http \
	    && a2ensite nextcloud.conf \
      && a2dissite 000-default default-ssl \
      && rm /var/www/html/index.html

# Configure APCU
RUN echo "apc.enable_cli = 1" > /etc/php/"${PHP_VERSION}"/mods-available/apcu-cli.ini \
  && phpenmod apcu-cli \
  && php --ri apcu | grep 5.1.9

# Configure redis
RUN echo "extension=redis.so" > /etc/php/"${PHP_VERSION}"/mods-available/redis.ini \
  && phpenmod redis \
  && php --ri redis | grep 3.1.6

EXPOSE 80
EXPOSE 443

COPY entrypoint /entrypoint

WORKDIR $HOME

CMD [ "/entrypoint" ]

