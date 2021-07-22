FROM alpine:3.10

# mysql start
RUN mkdir -p /data/ && mkdir /data/mysql
VOLUME /data
WORKDIR /data
RUN mkdir -p /run/mysqld/ && touch /run/mysqld/mysqld.sock
RUN chown -R mysql:mysql /run/mysqld

RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*

# These lines moved to the end allow us to rebuild image quickly after only these files were modified.
COPY startup.sh /startup.sh
RUN chmod 777 -R /startup.sh
COPY mysql/my.cnf /etc/mysql/my.cnf
EXPOSE 3306
CMD ["/startup.sh"]
# mysql end
