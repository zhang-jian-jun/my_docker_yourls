FROM ubuntu:18.04
FROM mysql:5.7.25
MAINTAINER zjj "wusen@126.com"

# 使用yum的方式安装mysql；
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

# 安装完成以后，执行以下命令。配置用户名密码相关信息；
RUN /etc/init.d/mysqld start &&\
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'root1234' WITH GRANT OPTION ;"&&\
    mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'root1234' WITH GRANT OPTION ;"&&\
    mysql -u root -proot1234 -e "show databases;"

COPY sql.sh /mysql/sql.sh
COPY create.sql /mysql/create.sql
COPY privileges.sql /mysql/privileges.sql

# 镜像暴露3306端口；
EXPOSE 3306

# 容器启动后执行以下命令，启动mysql；
CMD ["/usr/bin/mysqld_safe"]
ENTRYPOINT  ["/mysql/sql.sh"]