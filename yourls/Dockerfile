#FROM ubuntu:18.04
FROM nginx:1.20.0

COPY ./nginx.conf /etc/nginx/nginx.conf

ENV RUN_USER www-data
ENV RUN_GROUP www-data
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]

#RUN apt-get update && \
#RUN yum install -y php7.4-cli php7.4-fpm php7.4-bcmath php7.4-gd php7.4-mbstring \
# php7.4-mysql php7.4-opcache php7.4-xml php7.4-zip php7.4-json php7.4-imagick
#RUN yum -y install php72w php72w-cli php72w-fpm php72w-common php72w-devel php72w-embedded php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache php72w-pdo php72w-xml

#update-alternatives --set php /usr/bin/php7.4

#RUN apt-get update
#RUN apt-get install -y php php-fpm php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php

