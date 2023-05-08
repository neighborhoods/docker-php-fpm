FROM php:8.1-fpm AS php-8.1-base

# Install base libs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        jq \
        openssh-client \
        wget \
        git \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libxml2-dev \
        libedit-dev \
        libc-client-dev \
        libkrb5-dev \
        libzookeeper-mt-dev \
        libpcre3-dev \
        libzip-dev \
        libonig-dev \
        gcc \
        make \
        re2c \
        gettext-base \
        && \
    rm -r /var/lib/apt/lists/*

## Install PHP core modules
RUN docker-php-ext-install \
    soap \
    zip \
    ftp \
    sockets \
    bcmath \
    mbstring \
    pcntl \
    posix \
    sysvmsg \
    sysvsem \
    sysvshm

# Install gd
RUN docker-php-ext-configure gd \
        --with-jpeg \
        --with-freetype && \
    docker-php-ext-install gd

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql

## Install Redis
RUN pecl install redis-5.3.4 && \
    docker-php-ext-enable redis

## Install Memcached
RUN pecl install memcached \
    && docker-php-ext-enable memcached

## Install IMAP
RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
	docker-php-ext-install imap

## Install Zookeeper
## FIXME: Making this way too dynamic php8.1 not yet supported in a release but is supported on master
## Probably want to go to v0.6.4 as soon as its released
RUN curl -L -o /tmp/zookeeper.tar.gz https://github.com/php-zookeeper/php-zookeeper/archive/refs/heads/master.tar.gz \
    && mkdir -p /tmp/zookeeper \
    && tar xfz /tmp/zookeeper.tar.gz -C /tmp/zookeeper --strip-components=1 \
    && rm -r /tmp/zookeeper.tar.gz \
    && docker-php-ext-install /tmp/zookeeper \
    && rm -r /tmp/zookeeper

## Install Opcache
RUN docker-php-ext-install opcache && \
    docker-php-ext-enable opcache

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

ENV CONF_DIR="/usr/local/etc/php/conf.d"

# Datadog build stage
FROM php-8.1-base AS php-8.1-datadog
RUN curl -SsLo datadog-php-tracer.deb https://github.com/DataDog/dd-trace-php/releases/download/0.52.0/datadog-php-tracer_0.52.0_amd64.deb \
    && dpkg -i datadog-php-tracer.deb
