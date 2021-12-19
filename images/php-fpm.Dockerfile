ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# Set time
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    zip \
    unzip \
    libxml2-dev \
    libzip-dev \
    libxslt1-dev \
    libpq-dev \
    librabbitmq-dev \
    libssh-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev

COPY configs/php-fpm.ini $PHP_INI_DIR/conf.d/

## Install PHP ext
RUN docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    zip \
    xsl \
    bcmath \
    sockets

## Instal xdebug
ARG XDEBUG_VERSION
RUN yes | pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug

## Clear image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/app
