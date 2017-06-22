FROM ubuntu:17.10

LABEL maintainer "plokplokplok@163.com"

#公共配置
RUN apt-get -y update
RUN apt-get install -y nginx
RUN apt-get install -y software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php7.1
RUN apt-get install -y php7.1-mbstring php7.1-curl php7.1-xml php7.1-gd php7.1-mysql php-memcached php-redis php7.1-mcrypt php-ssh2 php7.1-bcmath

#外部容器端口可以访问
RUN rm -rf /etc/nginx/sites-enabled/default

COPY nginx/fastcgi_params /etc/nginx/fastcgi_params

COPY nginx/conf.d /etc/nginx/conf.d

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
