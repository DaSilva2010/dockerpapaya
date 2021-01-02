FROM php:7.3-apache
MAINTAINER DaSilva2010 <dasilva2010@arcor.de>

ENV PAPAYA_VERSION 6.13.4
# install needed tools
RUN apt-get update; \
    apt-get -y --no-install-recommends install git wget libxslt-dev libmcrypt-dev libpng-dev libjpeg-dev libmcrypt-dev libmagickwand-dev libzip-dev zip unzip; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install -j "$(nproc)" xsl mysqli gd zip; \
    pecl install imagick-3.4.4; \
    pecl install --nodeps mcrypt-snapshot; \
    pecl install xhprof; \
    docker-php-ext-enable imagick; \
    docker-php-ext-enable mcrypt; \
    docker-php-ext-enable xhprof; \
    echo [Date] > $PHP_INI_DIR/conf.d/docker-php-ext-date.ini; \
    echo date.timezone = UTC >> $PHP_INI_DIR/conf.d/docker-php-ext-date.ini

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN set -eux; \
	docker-php-ext-enable opcache; \
	{ \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN set -eux; \
	a2enmod rewrite expires; \
	\
# https://httpd.apache.org/docs/2.4/mod/mod_remoteip.html
	a2enmod remoteip; \
	{ \
		echo 'RemoteIPHeader X-Forwarded-For'; \
# these IP ranges are reserved for "private" use and should thus *usually* be safe inside Docker
		echo 'RemoteIPTrustedProxy 10.0.0.0/8'; \
		echo 'RemoteIPTrustedProxy 172.16.0.0/12'; \
		echo 'RemoteIPTrustedProxy 192.168.0.0/16'; \
		echo 'RemoteIPTrustedProxy 169.254.0.0/16'; \
		echo 'RemoteIPTrustedProxy 127.0.0.0/8'; \
	} > /etc/apache2/conf-available/remoteip.conf; \
	a2enconf remoteip; \
# https://github.com/docker-library/wordpress/issues/383#issuecomment-507886512
# (replace all instances of "%h" with "%a" in LogFormat)
	find /etc/apache2 -type f -name '*.conf' -exec sed -ri 's/([[:space:]]*LogFormat[[:space:]]+"[^"]*)%h([^"]*")/\1%a\2/g' '{}' +

# installing composer and phing
COPY install-composer.sh /tmp/install-composer.sh
RUN chmod +x /tmp/install-composer.sh; \
    /tmp/install-composer.sh

WORKDIR /var/www
RUN chown -R www-data:www-data /var/www

USER www-data
# load and install papaya core system
RUN wget https://github.com/papayaCMS/papayacms-core/archive/${PAPAYA_VERSION}.zip -O papaya-core.zip; \
    unzip papaya-core.zip; \
    rm papaya-core.zip; \
    cd papayacms-core-${PAPAYA_VERSION}; \
    rm composer.lock; \
    composer install

# create and setup a new project
RUN composer --ansi create-project papaya/cms-project dockerpapaya; \
    cd /var/www/dockerpapaya; \
    composer require papaya/theme-dynamic; \
    composer require papaya/module-mail

EXPOSE 80 443
VOLUME /var/www/dockerpapaya/papaya-data

USER root
ADD papayacms.conf /etc/apache2/sites-available/
RUN rm /etc/apache2/sites-enabled/*.conf; ln -s /etc/apache2/sites-available/papayacms.conf /etc/apache2/sites-enabled/papayacms.conf

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
