FROM ubuntu:18.04
FROM mysql:5.7.25
MAINTAINER zjj "wusen@126.com"

# 使用yum的方式安装mysql；
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

COPY sql.sh /mysql/sql.sh
COPY create.sql /mysql/create.sql
COPY privileges.sql /mysql/privileges.sql

# 镜像暴露3306端口；
EXPOSE 3306

# 容器启动后执行以下命令，启动mysql；
CMD ["/usr/bin/mysqld_safe"]
ENTRYPOINT  ["/mysql/sql.sh"]