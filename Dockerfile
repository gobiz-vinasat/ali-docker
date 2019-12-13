#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------

FROM php:5.4-apache

ARG APACHE_DOCUMENT_ROOT=/var/www/html
ENV APACHE_DOCUMENT_ROOT ${APACHE_DOCUMENT_ROOT}

ARG APACHE_LOG_DIR=/var/log/apache2/
ENV APACHE_LOG_DIR ${APACHE_LOG_DIR}

#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------

# Packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    nano \
    zip \
    unzip \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    libzip-dev \
    supervisor \
  && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip \
    calendar \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install gd \
  && pecl install redis-2.2.8 && docker-php-ext-enable redis \
  && pecl install mongo && docker-php-ext-enable mongo

# Composer
RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#--------------------------------------------------------------------------
# Software's Configuration
#--------------------------------------------------------------------------

RUN mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
COPY apache-site.conf /etc/apache2/sites-enabled/app.conf
COPY php.ini /usr/local/etc/php/php.ini
