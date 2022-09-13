FROM registry.ipv6.docker.com/komandar/nginx-php:8.1

# Copy project inside docker container
COPY --chown=www-data:www-data ./src /var/www/app

# Setup Laravel
RUN composer install -q --optimize-autoloader --no-dev --no-interaction \
   && chmod -R 755 storage bootstrap/cache \
   && php artisan storage:link \
   && php artisan optimize \
   && php artisan view:cache
