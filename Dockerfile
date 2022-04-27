FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="git@gitlab.altex.ro:iac/images.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.altex" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP 7.2, Nginx, and Alpine" \
      org.label-schema.url="https://gitlab.altex.ro/iac/images.git"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.2

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        nginx \
        nginx-mod-http-headers-more \
        curl \
        ca-certificates \
        runit \
        # PHP7.2
        php7.2 \
        php7.2-intl \
        php7.2-zip  \
        php7.2-fpm  \
        php7.2-common   \
        php7.2-xml  \
        php7.2-xmlwriter    \
        php7.2-xmlreader    \
        php7.2-gd   \
        php7.2-mysqlnd  \
        php7.2-soap \
        php7.2-mcrypt   \
        php7.2-pdo  \
        php7.2-bcmath   \
        php7.2-pear \
        php7.2-redis    \
        php7.2-dev  \
        php7.2-mbstring \
        php7-pecl-igbinary  \
        php7.2-json \
        php7.2-opcache  \
        # Extra
        php7.2-curl \
        php7.2-simplexml    \
        php7.2-zlib    \
        # XDEBUG
        ## php7.2-xdebug  \
"
# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY tags/nginx /

EXPOSE 80

CMD ["/sbin/runit-wrapper"]
