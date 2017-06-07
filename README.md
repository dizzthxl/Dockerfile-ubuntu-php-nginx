# Dockerfile-ubuntu16.04-php7.0-nginx Docker
useage:
1:将项目的nginx配置文件放入nginx/conf.d目录下
2:将项目放入project目录下【会复制到容器内opt目录下，需与nginx config一致】
 例：如果将项目文件夹test放入project目录下，nginx目录配置里root需设置为/opt/test
