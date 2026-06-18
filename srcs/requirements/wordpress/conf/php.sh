#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; 
then 
	cp wp-config-sample.php wp-config.php
	sed -i "s/database_name_here/$MY_SQL_DATABASE/" wp-config.php
	sed -i "s/username_here/$MY_SQL_USER/" wp-config.php
	sed -i "s/password_here/$MY_SQL_PASSWORD/" wp-config.php
	sed -i "s/localhost/mariadb/" wp-config.php

	curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
fi

echo "Mariadb connection from Wordpress..." # waiting till mariadb is on
until mysql -h mariadb -u"$MY_SQL_USER" -p"$MY_SQL_PASSWORD" -e "SELECT 1;" &> /dev/null #select to ping + &> to redirect stdout and stderr 
do
	echo "..."
    sleep 1
done
echo "Mariadb online!!!"


if ! mysql -h mariadb -u"$MY_SQL_USER" -p"$MY_SQL_PASSWORD" "$MY_SQL_DATABASE" -e "SELECT ID FROM wp_users LIMIT 1;" &> /dev/null #installation wordpress
then
	echo "Wordpress Installation... ... ..."
	if [ ! -f /usr/local/bin/wp ];
	then
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc
		curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp | gpg --import
		gpg --verify wp-cli.phar.asc wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp
		wp --info
	fi
	wp core download --path=/var/www/html --allow-root
	wp config create --path=/var/www/html --dbname="$MY_SQL_DATABASE" --dbuser="$MY_SQL_USER" --dbpass="$MY_SQL_PASSWORD" --dbhost="mariadb" --allow-root
	wp config shuffle-salts --path=/var/www/html --allow-root
	wp core install --path=/var/www/html --url="$DOMAIN_NAME" --title="inception?" --admin_user="$WP_USER" --admin_password="$WP_PASS" --admin_email="$WP_MAIL" --skip-email --allow-root
	wp user create "$WP_USER2" "$WP_MAIL2" --role=editor --user_pass="$WP_PASS2" --path=/var/www/html --allow-root
	# wp user set-role "$WP_USER2" editor --path=/var/www/html --allow-root
	chown -R www-data:www-data /var/www/html || true
	# ADMIN_H=$(php -r "echo password_hash('$WP_PASS', PASSWORD_DEFAULT);")
	# mysql -h mariadb -u"$MY_SQL_USER" -p"$MY_SQL_PASSWORD" "$MY_SQL_DATABASE" -e <<EOF 
	# INSERT INTO wp_users (ID, user_login, user_pass, user_email, user_registered, user_status, display_name)
	# VALUES (1, '$WP_USER', '$ADMIN_H', '$WP_MAIL', NOW(), 0, '$WP_USER');
	# INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
	# # VALUES (1, 'wp_capabilities, 'a:1:{s:13:\"administrator\";b:1;}');

	# EOF
fi

PHP=$(ls /usr/sbin/php-fpm* | head -n 1)

exec $PHP -F