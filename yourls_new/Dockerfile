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
RUN apk add gcc gcc-c++ autoconf automake make wget \
    bison ncurses-devel

#创建临时目录
# 通过wget下载或者通过ADD直接添加二选一的方式获得cmake和mysql包,在测试的使用使用ADD
RUN mkdir -p /tmp/mysql && \
    wget -P /tmp/mysql http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz && \
    wget -P /tmp/mysql http://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.23.tar.gz
#ADD Lib/mysql-5.5.23/cmake-2.8.5.tar.gz /tmp/mysql
#ADD Lib/mysql-5.5.23/mysql-5.5.23.tar.gz /tmp/mysql

# 解压cmake包并安装
RUN cd /tmp/mysql && \
    tar xzvf cmake-2.8.5.tar.gz && \
    cd /tmp/mysql/cmake-2.8.5 && \
    ./configure && \
    make && \
    make install

#下载mysql包,解压之后进入到目录进行安装
RUN cd /tmp/mysql && \
    tar xzvf mysql-5.5.23.tar.gz && \
    cd /tmp/mysql/mysql-5.5.23 && \
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
          -DMYSQL_DATADIR=/data/mysql/data \
          -DWITH_MYISAM_STORAGE_ENGINE=1 \
          -DWITH_INNOBASE_STORAGE_ENGINE=1 \
          -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
          -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
          -DENABLED_LOCAL_INFILE=1 \
          -DDEFAULT_CHARSET=utf8 \
          -DDEFAULT_COLLATION=utf8_general_ci \
          -DEXTRA_CHARSETS=all \
          -DMYSQL_TCP_PORT=3306 && \
    make && \
    make install

#使用ADD直接把配置文件复制进去
ADD mysql/my.cnf /etc/
ADD mysql/mysqld /etc/init.d/

#建立mysql,mysqldump,mysqladmin的软链接
RUN cd /usr/local/bin && \
    ln -s /usr/local/mysql/bin/mysql mysql && \
    ln -s /usr/local/mysql/bin/mysqldump mysqldump && \
    ln -s /usr/local/mysql/bin/mysqladmin  mysqladmin

#清除操作
RUN apk add clean all && rm -rf /tmp/yum* && rm -rf /tmp/mysql

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
