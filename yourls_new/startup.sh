#!/bin/sh

mkdir -p /run/mysqld/
touch /run/mysqld/mysqld.sock
chown -R mysql:mysql /run/mysqld
mysql_install_db --user=mysql --ldata=/data/mysql > /dev/null
# parameters
MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-"mysql"}
MYSQL_USER=${MYSQL_USER:-"root"}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-"root1234"}
MYSQL_USER_DB=${MYSQL_USER_DB:-"db_yourl"}

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi
#if [ -d /data/mysql ]; then
#  echo "[i] MySQL directory already present, skipping creation"
#else
#  echo "[i] MySQL data directory not found, creating initial DBs"
#
#	chown -R mysql:mysql /data/mysql
#
#	# init database
#	echo 'Initializing database'
#	mysql_install_db --user=mysql --ldata=/data/mysql > /dev/null
#	echo 'Database initialized'
#
#	echo "[i] MySql root password: $MYSQL_ROOT_PWD"
#
#	# create temp file
#	tfile=`mktemp`
#	if [ ! -f "$tfile" ]; then
#	    return 1
#	fi
#
#	# save sql
#	echo "[i] Create temp file: $tfile"
#	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION;
EOF


	# Create new database
	if [ "$MYSQL_USER_DB" != "" ]; then
		echo "[i] Creating database: $MYSQL_USER_DB"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_USER_DB\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

		# set new User and Password
		if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_USER_PWD" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_USER_PWD"
		echo "GRANT ALL ON \`$MYSQL_USER_DB\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD';" >> $tfile
		fi
	else
		# don`t need to create new database,Set new User to control all database.
		if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_USER_PWD" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_USER_PWD"
		echo "GRANT ALL ON *.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD';" >> $tfile
		fi
	fi

	echo 'FLUSH PRIVILEGES;' >> $tfile

	# run sql in tempfile
	echo "[i] run tempfile: $tfile"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-networking=0 < $tfile
	rm -f $tfile
fi

echo "[i] Sleeping 5 sec"
sleep 5

echo '[i] start running mysqld'
exec /usr/bin/mysqld --user=mysql --console --skip-networking=0