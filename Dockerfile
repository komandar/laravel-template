ARG NGINX_SERVERNAME=example.com
ARG PHP_VERSION=8.1

#FROM komandar/nginx-php:${PHP_VERSION}
FROM locally/local:v5

# Overwrite variables with build-args
RUN sed -i "s/appurl/${NGINX_SERVERNAME}/g" /etc/nginx/http.d/default.conf

# Copy project folder inside docker
COPY --chown=www-data:www-data ./src /var/www/app

WORKDIR /var/www/app

# Setup Laravel
RUN composer install -q --optimize-autoloader --no-dev --no-interaction \
    && chmod -R 755 storage bootstrap/cache \
    && php artisan storage:link \
    && php artisan optimize \
    && php artisan view:cache

USER www-data:www-data
