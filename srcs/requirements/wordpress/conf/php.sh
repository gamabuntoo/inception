#!/bin/sh



echo "Mariadb connection from Wordpress..." # waiting till mariadb is on
until mysql -h mariadb -u"$MY_SQL_USER" -p"$MY_SQL_PASSWORD" -e "SELECT 1;" &> /dev/null #select to ping + &> to redirect stdout and stderr 
do
	echo ". . ."
    sleep 1
done
echo "Mariadb online!!!"


if ! mysql -h mariadb -u"$MY_SQL_USER" -p"$MY_SQL_PASSWORD" "$MY_SQL_DATABASE" -e "SELECT ID FROM wp_users LIMIT 1;" &> /dev/null #installation wordpress
then
	echo "Wordpress Installation... ... ..."
	chown -R www-data:www-data /var/www/html || true
	if [ -f /usr/local/bin/salade.aaa ];
	then
		echo "already installed" 
		break
	fi
	if [ ! -f /usr/local/bin/wp ];
	then
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.asc
		curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/wp-cli.pgp | gpg --import
		gpg --verify wp-cli.phar.asc wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp
		wp --info
		echo "\n\n\t  wordpress cli installed\n\n"
	fi
	if [ ! -f /var/www/html/wp-config-sample.php ]; then
		wp core download --path=/var/www/html --allow-root
		echo "\n\n wordpress core downloaded to /var/www/html"
	fi	
	wp config create --path=/var/www/html \
		--dbname="$MY_SQL_DATABASE" \
		--dbuser="$MY_SQL_USER" \
		--dbpass="$MY_SQL_PASSWORD" \
		--dbhost="mariadb" --allow-root
	echo $?
	echo "\n\nconfiguration created"
	cat /var/www/html/wp-config.php

	if [ ! -f /var/www/html/wp-config.php ]; then
		echo "\n\n"
		echo "hi from wp config"
		# cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
		# chmod +x /var/www/html/wp-config.php
		# chown -R www-data:www-data /var/www/html/wp-config.php
		ls -l /var/www/html/
		ls -l /var/www/html/ | grep 'wp-config'
		# sed -i "s/database_name_here/$MY_SQL_DATABASE/" /var/www/html/wp-config.php
		# sed -i "s/username_here/$MY_SQL_USER/" /var/www/html/wp-config.php
		# sed -i "s/password_here/$MY_SQL_PASSWORD/" /var/www/html/wp-config.php # bloc com temporaire 
		# sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php

		# # curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php
		# touch /usr/local/bin/salade.aaa
		# echo "\n\n salted"
	fi
	wp config shuffle-salts --path=/var/www/html --allow-root
	echo "\n\n salted 2"

	wp core install --path=/var/www/html --url="$DOMAIN_NAME" \
		--title="inception?" \
		--admin_user="$WP_USER" \
		--admin_password="$WP_PASS" \
		--admin_email="$WP_MAIL" --skip-email --allow-root

	echo "\n\nDOmain configured $DOMAIN_NAME"

	wp user create "$WP_USER2" "$WP_MAIL2" --role=editor \
		--user_pass="$WP_PASS2" \
		--path=/var/www/html --allow-root

	echo "\n\nUsers sets"

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