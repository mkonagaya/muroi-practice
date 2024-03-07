FROM php:8.2-fpm

# COPY php.ini
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini

# Composer install
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

# install packages including Node.js
RUN apt-get update && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get -y install \
    nodejs\
    git \
    zip \
    unzip \
    vim \
    libpng-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-install pdo_mysql bcmath \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /

RUN mkdir /app

RUN chmod -R 2777 /app

WORKDIR /app