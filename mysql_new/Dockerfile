# 基于centos7的mysql5.5.23的镜像
# 使用mysql源码编译安装

# 设置基础镜像位centos:7,Set the base image to centos:7
FROM centos:7

# 定义作者
MAINTAINER wuxyyin/wuxyyin@qq.com

#安装必要的工具包
RUN yum -y install gcc gcc-c++ autoconf automake make wget \
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
ADD my.cnf /etc/
ADD mysqld /etc/init.d/

#建立mysql,mysqldump,mysqladmin的软链接
RUN cd /usr/local/bin && \
    ln -s /usr/local/mysql/bin/mysql mysql && \
    ln -s /usr/local/mysql/bin/mysqldump mysqldump && \
    ln -s /usr/local/mysql/bin/mysqladmin  mysqladmin

#清除操作
RUN yum clean all && rm -rf /tmp/yum* && rm -rf /tmp/mysql

# 暴露目录，目前只暴露/data/mysql目录
VOLUME ["/data/mysql"]

# 暴露端口
EXPOSE 3306

# 加载启动脚本
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

# 在容器启动的时候默认执行
ENTRYPOINT "/entrypoint.sh"