FROM ubuntu:18.04

# 安装软件
#RUN apt-get -y update && apt-get -y install gcc gdb strace gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs patch e2fsprogs-devel krb5-devel libidn libidn-devel openldap-devel nss_ldap openldap-clients openldap-servers libevent-devel libevent uuid-devel uuid openssl openssl-devel pcre pcre-devel
RUN apt-get -y install gcc*  make pcre-devel zlib-devel openssl openssl-devel libxslt-devel gd gd-devel GeoIP GeoIP-devel pcre pcre-devel
RUN groupadd www
RUN useradd -g www www -s /bin/false

ENV VERSION 1.14.2

# 下载并解压文件
RUN mkdir -p /usr/local/src/
ADD http://nginx.org/download/nginx-$VERSION.tar.gz /usr/local/src
RUN tar -xvf /usr/local/src/nginx-$VERSION.tar.gz -C /usr/local/src/

# 创建安装目录
ENV NGINX_HOME /usr/local/nginx
RUN mkdir -p $NGINX_HOME
RUN chown -R www:www $NGINX_HOME

# 进入解压目录
WORKDIR /usr/local/src/nginx-$VERSION

# 编译安装
RUN ./configure \
	--user=www \
	--group=www \
	--prefix=$NGINX_HOME \
	--with-http_ssl_module \
	--with-http_realip_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module
RUN make
RUN make install

# 备份Nginx的配置文件
COPY /usr/local/nginx/conf/nginx.conf $NGINX_HOME/conf/nginx.conf
RUN mv $NGINX_HOME/conf/nginx.conf $NGINX_HOME/conf/nginx.conf.default

# 设置环境变量
ENV PATH $PATH:$NGINX_HOME/sbin

# 创建WebApp目录
#ENV WEB_APP /usr/share/nginx/html
#RUN mkdir -p $WEB_APP

# 设置默认工作目录
#WORKDIR $WEB_APP

# 暴露端口
EXPOSE 80
EXPOSE 443

# 清理压缩包与解压文件
RUN rm -rf /usr/local/src/nginx*

CMD $NGINX_HOME/sbin/nginx -g 'daemon off;' -c $NGINX_HOME/conf/nginx.conf

RUN apt-get update && \
apt-get install -y php7.4-cli php7.4-fpm php7.4-bcmath php7.4-gd php7.4-mbstring \
 php7.4-mysql php7.4-opcache php7.4-xml php7.4-zip php7.4-json php7.4-imagick

#update-alternatives --set php /usr/bin/php7.4

#RUN apt-get update
#RUN apt-get install -y php php-fpm php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN set -eux; \
    curl -o yourls.tar.gz -fsSL "https://github.com/YOURLS/YOURLS/archive/refs/tags/1.8.1.tar.gz"; \
# upstream tarballs include ./YOURLS-${YOURLS_VERSION}/ so this gives us /usr/src/YOURLS-${YOURLS_VERSION}
    tar -xf yourls.tar.gz -C /usr/src/; \
# move back to a common /usr/src/yourls
    mv "/usr/src/YOURLS-1.8.1" /usr/src/yourls; \
    rm yourls.tar.gz; \
    chown -R www-data:www-data /usr/src/yourls

COPY docker-entrypoint.sh /usr/local/bin/
COPY config-docker.php /usr/src/yourls/user/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["systemctl start php7.4-fpm"]
