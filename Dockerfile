######## INSTALL ########

# Set the base image
FROM freeasso/debian-12

# Env
ENV DEBIAN_FRONTEND=noninteractive
ENV PHP_VER=8.3

# Installation de PHP 
RUN apt-get update -y && apt-get upgrade -y
RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt update -y
RUN apt-get install -y libzmq3-dev
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y php${PHP_VER} php${PHP_VER}-cli php${PHP_VER}-common
RUN apt-get install -y php${PHP_VER}-mbstring php${PHP_VER}-xml php${PHP_VER}-soap
RUN apt-get install -y php${PHP_VER}-dev php${PHP_VER}-tidy php${PHP_VER}-zip php${PHP_VER}-memcached
RUN apt-get install -y php${PHP_VER}-curl php${PHP_VER}-gd php${PHP_VER}-intl php${PHP_VER}-gmp php${PHP_VER}-zmq
RUN apt-get install -y php${PHP_VER}-xdebug 
RUN apt-get install -y php${PHP_VER}-redis php${PHP_VER}-mysql
RUN apt-get install -y php${PHP_VER}-fpm 

# Standardize PHP executable location
RUN rm -f /etc/alternatives/php && ln -s /usr/bin/php${PHP_VER} /etc/alternatives/php
RUN rm -f /etc/alternatives/phar.phar && ln -s /usr/bin/phar.phar${PHP_VER} /etc/alternatives/phar.phar
RUN rm -f /etc/alternatives/phpize && ln -s /usr/bin/phpize${PHP_VER} /etc/alternatives/phpize
RUN rm -f /usr/sbin/php-fpm && ln -s /usr/sbin/php-fpm${PHP_VER} /usr/sbin/php-fpm
RUN mkdir -p /run/php

# PHP config
COPY docker/apache2.php.ini /etc/php/${PHP_VER}/apache2/
COPY docker/cli.php.ini /etc/php/${PHP_VER}/cli/
COPY docker/fpm.php.ini /etc/php/${PHP_VER}/fpm/
COPY docker/www.conf /etc/php/${PHP_VER}/fpm/pool.d/

# Installation de composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Volumes & ports
EXPOSE 9000
EXPOSE 9080
EXPOSE 8080

VOLUME ["/var/www/html"]
WORKDIR /var/www/html

# Supervisor
RUN /etc/init.d/php${PHP_VER}-fpm stop
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/php-fpm.conf
CMD ["/usr/bin/supervisord", "-n"]