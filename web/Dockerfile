FROM php:8.2-apache
ARG ROOT_DIRECTORY
ENV ROOT_DIRECTORY=$ROOT_DIRECTORY
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get -y --quiet install --no-install-recommends \
       libpng-dev \
       ssmtp \
       mailutils \
       libmcrypt-dev \
       libfreetype6-dev \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -fr /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
RUN docker-php-ext-configure pdo_mysql && docker-php-ext-install pdo_mysql \
 && docker-php-ext-configure gd --with-freetype \
 && docker-php-ext-install gd
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN curl -sL https://github.com/orsee/orsee/archive/refs/tags/orsee_3.2.0.tar.gz -o /tmp/orsee.tar.gz \
 && tar -xvzf /tmp/orsee.tar.gz -C /tmp \
 && rm -f /tmp/orsee.tar.gz \
 && mv /tmp/orsee-orsee_3.2.0 /var/www/html$ROOT_DIRECTORY
RUN rm /etc/ssmtp/ssmtp.conf
COPY ./ /
RUN chmod +x /usr/local/bin/startup.sh
CMD /usr/local/bin/startup.sh && apache2-foreground