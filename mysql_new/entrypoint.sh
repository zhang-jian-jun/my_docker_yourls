#!/bin/bash

#创建mysql用户组和用户
groupadd -g 3306 mysql
useradd -u 3306 -g mysql -M -s /sbin/nologin mysql
mkdir -p /data/mysql/data
mkdir -p /data/mysql/log
touch /data/mysql/log/mysql.err.log
chown -R mysql:mysql /data
chmod -R 755 /data

#初始化数据库
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql/data
chmod +x /etc/init.d/mysqld
#/sbin/chkconfig --add mysqld
#/sbin/chkconfig mysqld on

# 在构建完容器之后启动mysql
# 设置root默认密码,默认是空密码
/etc/init.d/mysqld start

# 创建root用户设置root密码
MYSQL_ROOT_PASSWORD="qishon_ms"
mysql -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"

# 指定host
if [ -z "${MYSQL_HOST}" ]; then
    MYSQL_HOST="%"
fi

# 默认创建的数据库
if [ -z "${MYSQL_DATABASE}" ]; then
    MYSQL_DATABASE="qishon"
fi

# 默认创建的用户-a=&& -o=||
#if [ -n "${MYSQL_USER}" -a -n "${MYSQL_PASSWORD}" ]; then
#    mysql -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_HOST}' IDENTIFIED BY '${MYSQL_PASSWORD}'"
#    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'${MYSQL_HOST}'"
#fi
if [ -z "${MYSQL_USER}" ]; then
    MYSQL_USER="qishon"
fi
if [ -z "${MYSQL_PASSWORD}" ]; then
    MYSQL_PASSWORD="qishon"
fi

mysql -e "CREATE DATABASE ${MYSQL_DATABASE}"
mysql -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_HOST}' IDENTIFIED BY '${MYSQL_PASSWORD}'"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'${MYSQL_HOST}'"

# 输出mysql的错误日志
tail -f /data/mysql/log/mysql.err.log
# 前台常驻进程，tail -f也已经是前台常驻进程了
/bin/bash