#!/bin/sh

mkdir -p /run/mysqld/
touch /run/mysqld/mysqld.sock
chown -R mysql:mysql /run/mysqld
mysql_install_db --user=mysql --ldata=/data/mysql > /dev/null

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi
echo '[i] start running mysqld'
exec /usr/bin/mysqld --user=mysql --console > /dev/null

mysqld --user=mysql > /dev/null
mysql -h localhost -P 3306 -u root <my.sql