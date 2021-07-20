FROM ubuntu:18.04
MAINTAINER zjj "wusen@126.com"
#RUN apt-get update && apt-get install -y vim &&  apt-get install -y nginx
#COPY /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf
#EXPOSE 80
#CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]

# 安装软件
RUN apt-get -y update && apt-get -y install gcc gdb strace gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs patch e2fsprogs-devel krb5-devel libidn libidn-devel openldap-devel nss_ldap openldap-clients openldap-servers libevent-devel libevent uuid-devel uuid openssl openssl-devel pcre pcre-devel

# 创建用户
RUN groupadd www
RUN useradd -g www www -s /bin/false

# 定义Nginx版本号
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