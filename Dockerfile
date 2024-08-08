FROM php:8.3.10-apache

RUN apt update -y && apt install -y \
    git \
    zip

# xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
COPY ./conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Apache
COPY ./conf/apache.conf /etc/apache2/sites-available/000-default.conf
# enabling Apache mod rewrite, which allows for URL rewriting,
# URL rewriting is used to control routing and to make the URL more readable and SEO friendly
RUN a2enmod rewrite

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# user
RUN useradd -G www-data,root -u 1000 -d /home/webapp webapp
RUN mkdir -p /home/webapp/.composer && \
    chown -R webapp:webapp /home/webapp

# copy project
COPY --chown=webapp:www-data . /var/www/html

# change user
USER webapp

# set workdir
WORKDIR /var/www/html
