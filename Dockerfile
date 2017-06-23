FROM ubuntu:17.10

LABEL maintainer "plokplokplok@163.com"

RUN apt-get -y update

#fastdfs 安装
ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    P_V=7.1
RUN apt-get install -y git gcc make
RUN mkdir -p ${FASTDFS_PATH}/libfastcommon \
 && mkdir -p ${FASTDFS_PATH}/fastdfs \
 && mkdir ${FASTDFS_BASE_PATH}
WORKDIR ${FASTDFS_PATH}/libfastcommon
RUN git clone --depth 1 https://github.com/happyfish100/libfastcommon.git ${FASTDFS_PATH}/libfastcommon \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/libfastcommon
WORKDIR ${FASTDFS_PATH}/fastdfs
RUN git clone --depth 1 https://github.com/happyfish100/fastdfs.git ${FASTDFS_PATH}/fastdfs \
 && ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/fastdfs
COPY fastdfs/conf/*.* /etc/fdfs/


#php
RUN apt-get install -y software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php${P_V}-fpm
RUN apt-get install -y php${P_V}-mbstring php${P_V}-curl php${P_V}-xml php${P_V}-gd php${P_V}-mysql php-memcached php-redis php${P_V}-mcrypt php-ssh2 php${P_V}-bcmath
RUN apt remove -y apache2

#nginx
RUN apt-get install -y nginx
RUN rm -rf /etc/nginx/sites-enabled/default
COPY nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY nginx/conf.d /etc/nginx/conf.d


#获取扩展目录文件名
COPY fastdfs/ext/fastdfs_client.so /usr/lib/php/20160303/fastdfs_client.so
COPY fastdfs/ext/fastdfs_client.ini ${FASTDFS_PATH}/fastdfs/fastdfs_client.ini
RUN cat ${FASTDFS_PATH}/fastdfs/fastdfs_client.ini >> /etc/php/${P_V}/fpm/php.ini

#项目
COPY /project /opt
RUN chmod -R 777 /opt
WORKDIR /opt/

#启动
COPY start.sh /usr/bin/start.sh

#make the start.sh executable 
RUN chmod 777 /usr/bin/start.sh

#如不需要nginx，可去掉第二个参数
ENTRYPOINT ["/usr/bin/start.sh"]
