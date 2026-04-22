#!/bin/sh

PHP=$(ls /usr/sbin/php-fpm* | head -n 1)

exec $PHP -F