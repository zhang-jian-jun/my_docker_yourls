#FROM php:7.2-fpm
FROM php:8.0
RUN set -eux; \
    docker-php-ext-install -j "$(nproc)" bcmath opcache pdo_mysql mysqli
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
COPY ./config.php /usr/src/yourls/user/config.php
COPY ./config.php /usr/src/yourls/YOURLS-1.8.1/user/config.php
RUN chmod 755 -R /usr/local/bin/

# confiugure
RUN cp -R /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
#RUN cd /usr/local/etc/php \
#&& cp php.ini-production php.ini \
#&& sed -i 's/display_errors\s*=.*/display_errors = Off/' php.ini \
#&& sed -i 's/error_reporting\s*=.*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/' php.ini \
#&& sed -i 's/;error_log\s*=\s*php_errors\.log/error_log = \/var\/log\/php_errors.log/' php.ini \
#&& sed -i 's/;date\.timezone\s*=.*/date.timezone = Asia\/Shanghai/' php.ini
EXPOSE 9000
#ENTRYPOINT ["php-fpm"]

RUN apt-get update && apt-get install -y vim &&  apt-get install -y nginx
# 如上，以 && 符号连接命令，这样执行后，只会创建 1 层镜像。
#指定运行该镜像的容器使用的端口为 80
# docker run的时候 一定要加上 -P
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx.conf /usr/share/nginx/nginx.conf
EXPOSE 80




#CMD ["nginx","-g","daemon off;"]

#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
#CMD ["nginx","-s","reload"]


