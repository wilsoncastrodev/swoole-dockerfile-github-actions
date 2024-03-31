FROM openswoole/swoole:php8.3

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions pcntl sockets pgsql pdo_pgsql

COPY . /var/www/app
WORKDIR /var/www/app

COPY .env.example /var/www/app/.env

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer self-update \
    && composer install --no-dev \
    && composer require nunomaduro/collision --dev \
    && php artisan octane:install --server=swoole \
    && php artisan optimize:clear \
    && php artisan key:generate

EXPOSE 9801

CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=9801"]