#!/bin/sh

# service mysql start

if [ ! -d /run/mysqld ];
then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
	chmod -R 755 /run/mysqld
fi

mysqld --user=mysql --datadir=/var/lib/mysql & pid="$!"

echo "Waiting for MariaDB. . . ."
until mysqladmin ping --silent; do
	sleep 1
done
echo "Mariadb op"

echo "CREATE DATABASE IF NOT EXISTS $MY_SQL_DATABASE ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$MY_SQL_USER'@'%' IDENTIFIED BY '$MY_SQL_PASSWORD' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $MY_SQL_DATABASE.* TO '$MY_SQL_USER'@'%' ;" >> db1.sql
# echo "ALTER USER '$MY_SQL_USER'@'localhost' IDENTIFIED BY '$MY_SQL_PASSWORD' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql -uroot < db1.sql


# mysql -uroot < /tmp/init.sql || mysql -u root -e "SELECT 1;"
# mysql -uroot < db1.sql || mysql -u root -e "SELECT 1;"
# kill $(cat /var/run/mysqld/mysqld.pid)
wait "$pid"
# mysqld
