FROM alpine:3.10

ENV YOURLS_VERSION 1.7.4

RUN apk --update add \
    curl \
    php-apache2 \
    php-cli \
    php-curl \
    php-json \
    php-mysqli \
    php-zip \
    php-gd \
    php-pdo \
    php-pdo_mysql \
    php-mbstring \
    php-phar \
    php-xml \
    php-pear \
    php-bcmath \
    php-openssl && \
    rm -f /var/cache/apk/* && \
    curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer && \
    mkdir -p /var/www/html/ && chown -R apache:apache /var/www/html

# Get YOURLS release archive.
RUN cd /var/www/html && \
  wget https://github.com/YOURLS/YOURLS/archive/${YOURLS_VERSION}.tar.gz && \
  tar -xf ${YOURLS_VERSION}.tar.gz --strip-components=1 && rm ${YOURLS_VERSION}.tar.gz

# All config files.
COPY src/config.php /var/www/html/user/config.php
COPY src/.htaccess /var/www/html/user/.htaccess
COPY etc/apache2/httpd.conf /etc/apache2/httpd.conf
COPY etc/apache2/sites/ /etc/apache2/sites/
COPY etc/php/php.ini /etc/php7/php.ini
COPY scripts/entrypoint.sh /opt/entrypoint.sh
RUN chmod 777 -R /opt/entrypoint.sh

# mysql start
RUN apk update && \
    apk add mysql mysql-client && \
    rm -f /var/cache/apk/* && \
    addgroup mysql mysql && \
    mkdir run/mysqld && \
    touch /var/run/mysqld/mysqld.sock && \
    touch /var/run/mysqld/mysqld.pid && \
    chown -R mysql:mysql /var/run/mysqld/mysqld.sock && \
    chown -R mysql:mysql /var/run/mysqld/mysqld.pid && \
    chmod -R 644 /var/run/mysqld/mysqld.sock && \
    apk add openrc --no-cache

#使用ADD直接把配置文件复制进去
ADD mysql/my.cnf /etc/
ADD mysql/mysqld /etc/init.d/

#建立mysql,mysqldump,mysqladmin的软链接
RUN cd /usr/local/bin && \
    ln -s /usr/local/mysql/bin/mysql mysql && \
    ln -s /usr/local/mysql/bin/mysqldump mysqldump && \
    ln -s /usr/local/mysql/bin/mysqladmin  mysqladmin

#清除操作
#RUN apk add clean all && rm -rf /tmp/yum* && rm -rf /tmp/mysql

# 暴露目录，目前只暴露/data/mysql目录
VOLUME ["/data/mysql"]

# 暴露端口
EXPOSE 3306

# 加载启动脚本
ADD mysql/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# 在容器启动的时候默认执行
ENTRYPOINT "/entrypoint.sh"
# mysql end

EXPOSE 80

WORKDIR /var/www/html/
ENTRYPOINT [ "/opt/entrypoint.sh" ]
