FROM php:8.3.10-apache

RUN apt update -y && apt install -y \
    git \
    zip

# configure PHP for Cloud Run;
# precompile PHP code with opcache
RUN docker-php-ext-install -j "$(nproc)" opcache
RUN set -ex; \
  { \
    echo "; Cloud Run enforces memory & timeouts"; \
    echo "memory_limit = -1"; \
    echo "max_execution_time = 0"; \
    echo "; File upload at Cloud Run network limit"; \
    echo "upload_max_filesize = 32M"; \
    echo "post_max_size = 32M"; \
    echo "; Configure Opcache for Containers"; \
    echo "opcache.enable = On"; \
    echo "opcache.validate_timestamps = Off"; \
    echo "; Configure Opcache Memory (Application-specific)"; \
    echo "opcache.memory_consumption = 32"; \
  } > "$PHP_INI_DIR/conf.d/cloud-run.ini"

# Apache
COPY ./conf/apache.conf /etc/apache2/sites-available/000-default.conf
# use the PORT environment variable in Apache configuration files;
# https://cloud.google.com/run/docs/reference/container-contract#port
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
# enabling Apache mod rewrite, which allows for URL rewriting,
# URL rewriting is used to control routing and to make the URL more readable and SEO friendly
RUN a2enmod rewrite

# configure PHP for production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# user
RUN useradd -G www-data,root -u 1000 -d /home/webapp webapp
RUN mkdir -p /home/webapp/.composer && \
    chown -R webapp:webapp /home/webapp

# copy project
COPY --chown=webapp:www-data . /var/www/html

# remove apt cache to save space
RUN rm -rf /var/lib/apt/lists/*

# change user
USER webapp

# set workdir
WORKDIR /var/www/html

# install dependencies in prod
RUN composer install
