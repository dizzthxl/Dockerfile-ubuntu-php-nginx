FROM ubuntu:17.10

LABEL maintainer "plokplokplok@163.com"

#公共配置
RUN apt-get -y update
ENV P_V=7.1

#php
RUN apt-get install -y software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php${P_V}-fpm
RUN apt-get install -y php${P_V}-mbstring php${P_V}-curl php${P_V}-xml php${P_V}-gd php${P_V}-mysql php-memcached php-redis php${P_V}-mcrypt php-ssh2 php${P_V}-bcmath
RUN apt remove -y apache2
COPY php/php.ini  /etc/php/${P_V}/fpm/php.ini

#nginx
RUN apt-get install -y nginx
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
RUN chmod 777 /usr/bin/start.sh
#转码
RUN apt-get install tofrodos
RUN fromdos /usr/bin/start.sh
#如不需要nginx，可去掉第二个参数
ENTRYPOINT ["/usr/bin/start.sh"]
