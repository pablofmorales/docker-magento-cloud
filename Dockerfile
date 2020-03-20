FROM php:7.2-cli

MAINTAINER Pablo Morales <pablofmorales@gmail.com>

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \ 
    libicu-dev \ 
    libjpeg62-turbo-dev \ 
    libmcrypt-dev \ 
    libpng-dev \ 
    libxslt1-dev \ 
    libmcrypt-dev \
    tree \
    vim \
    zip \
    wget \
    zlib1g-dev \
    sendmail-bin \ 
    sendmail \ 
    sudo \ 
    cron \ 
    rsyslog \ 
    default-mysql-client \ 
    git \ 
    libzip-dev

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions

RUN docker-php-ext-install \
  dom \ 
  gd \ 
  intl \ 
  mbstring \ 
  pdo_mysql \ 
  xsl \ 
  zip \ 
  soap \ 
  bcmath \ 
  pcntl \
  sockets

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV MAGENTO_ROOT /var/www/magento

ENV DEBUG false
ENV UPDATE_UID_GID false

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_GITHUB_TOKEN ""
ENV COMPOSER_MAGENTO_USERNAME ""
ENV COMPOSER_MAGENTO_PASSWORD ""

VOLUME /root/.composer/cache

# Get composer installed to /usr/local/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install n98-magerun2.phar and move to /usr/local/bin/
RUN curl -O https://files.magerun.net/n98-magerun2.phar && chmod +x ./n98-magerun2.phar && mv ./n98-magerun2.phar /usr/local/bin/

# Install magedbm2.phar and move to /usr/local/bin
RUN curl -LO https://s3.eu-west-2.amazonaws.com/magedbm2-releases/magedbm2.phar && chmod +x ./magedbm2.phar && mv ./magedbm2.phar /usr/local/bin

# Install mageconfigsync and move to /usr/local/bin
RUN curl -L https://github.com/punkstar/mageconfigsync/releases/download/0.5.0-beta.1/mageconfigsync-0.5.0-beta.1.phar > mageconfigsync.phar && chmod +x ./mageconfigsync.phar && mv ./mageconfigsync.phar /usr/local/bin

# install magento code style
RUN curl -LO https://github.com/pablofmorales/PHP_CodeSniffer/raw/master/bin/phpcs > /usr/local/bin/phpcs && chmod +x /usr/local/bin/phpcs

# install composer checker
RUN curl -LO https://get.sensiolabs.org/security-checker.phar > security-checker && chmod a+x security-checker && mv security-checker /usr/local/bin

# Install magento cloud 
RUN curl -sS https://accounts.magento.cloud/cli/installer | php


CMD ["bash"]
