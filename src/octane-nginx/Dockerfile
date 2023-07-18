ARG UPSTREAM_CHANNEL=''
ARG PHP_VERSION='8.2'
ARG BASE_IMAGE="serversideup/php:${UPSTREAM_CHANNEL}${PHP_VERSION}-cli"

FROM ${BASE_IMAGE}

ARG PHP_VERSION='8.2'

LABEL maintainer="Peter Stovka <ps@stacktrace.sk>"

ENV BUILD_PHP_VERSION=$PHP_VERSION \
    MSMTP_RELAY_SERVER_HOSTNAME="mailhog" \
    MSMTP_RELAY_SERVER_PORT="1025"

# install`nginx` (web server) & `msmtp` (smtp client) & swoole
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        php${BUILD_PHP_VERSION}-swoole \
        msmtp \
        msmtp-mta \
        nginx \
    \
    # ensure web permissions are correct
    && chown -R webuser:webgroup /var/www/html/ \
    \
    # cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/www/html/* \
    && rm -f /etc/nginx/sites-enabled/default

# Copy over S6 configurations
COPY --chmod=755 etc/s6-overlay/ /etc/s6-overlay/

COPY etc/nginx/ /etc/nginx/

EXPOSE 80

ENTRYPOINT ["/init"]
