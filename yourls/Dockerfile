FROM php:7.2-fpm

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN mkdir -p /usr/src/ && mkdir -p /usr/src/yourls/
RUN set -eux; \
    curl -o yourls.tar.gz -fsSL "https://github.com/YOURLS/YOURLS/archive/refs/tags/1.8.1.tar.gz"; \
# upstream tarballs include ./YOURLS-${YOURLS_VERSION}/ so this gives us /usr/src/YOURLS-${YOURLS_VERSION}
    tar -xf yourls.tar.gz -C /usr/src/; \
# move back to a common /usr/src/yourls
    mv "/usr/src/YOURLS-1.8.1" /usr/src/yourls; \
    rm yourls.tar.gz; \
    chown -R www-data:www-data /usr/src/yourls

RUN mkdir -p /usr/local/bin/ && mkdir -p /usr/src/yourls/user/
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./config-docker.php /usr/src/yourls/user/config-docker.php
COPY ./config-docker.php /usr/src/yourls/YOURLS-1.8.1/user/config.php
RUN chmod 755 -R /usr/local/bin/

RUN apt-get update && apt-get install -y vim &&  apt-get install -y nginx
# 如上，以 && 符号连接命令，这样执行后，只会创建 1 层镜像。
#指定运行该镜像的容器使用的端口为 80
# docker run的时候 一定要加上 -P
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx.conf /usr/share/nginx/nginx.conf
EXPOSE 80
EXPOSE 9000
CMD ["nginx","-g","daemon off;"]
#CMD ["nginx","-c","/usr/share/nginx/nginx.conf"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/sbin/php-fpm"]


