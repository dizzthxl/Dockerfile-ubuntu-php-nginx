# Dockerfile-ubuntu17.01-php7.1-nginx Docker<br /> 
useage:<br /> 
1:将项目的nginx配置文件放入nginx/conf.d目录下<br /> 
2:将项目放入project目录下【会复制到容器内opt目录下，需与nginx config一致】<br /> 
 例：如果将项目文件夹test放入project目录下，nginx目录配置里root需设置为/opt/test<br /> 
3:php目录下为php.ini文件
