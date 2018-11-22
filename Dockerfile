FROM debian:9.6-slim

MAINTAINER Martin Handl <martin.handl@artinsolutions.com>

# Set TERM to suppress warning messages.
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN phpPkgs=" \
	apache2 \
	memcached \
        php7.0 \
        php7.0-bcmath \
        php7.0-bz2 \
        php7.0-cli \
        php7.0-common \
        php7.0-curl \
        php7.0-dba \
        php7.0-dev \
        php7.0-enchant \
        php7.0-fpm \
        php7.0-gd \
        php7.0-gmp \
        php7.0-imap \
        php7.0-intl \
        php7.0-json \
        php7.0-ldap \
        php7.0-mbstring \
        php7.0-mcrypt \
        php7.0-mysql \
        php7.0-opcache \
        php7.0-pspell \
        php7.0-readline \
        php7.0-recode \
        php7.0-snmp \
        php7.0-soap \
        php7.0-tidy \
        php7.0-xml \
        php7.0-xmlrpc \
        php7.0-xsl \
        php7.0-zip \
	php-memcached \
      " \
    && apt-get update \
    && apt-get install -y $phpPkgs \
    && apt-get clean

# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Install phpunit and put binary into $PATH
RUN curl -sSLo phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && chmod 755 phpunit.phar \
    && mv phpunit.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod 755 phpcs.phar \
    && mv phpcs.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcs.phar /usr/local/bin/phpcs \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod 755 phpcbf.phar \
    && mv phpcbf.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcbf.phar /usr/local/bin/phpcbf


COPY msmtprc /etc/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php", "-a"]

ENV DEBIAN_FRONTEND teletype

