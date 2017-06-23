#!/bin/bash

service php7.1-fpm start && service nginx start

tail -f /var/log/nginx/error.log
