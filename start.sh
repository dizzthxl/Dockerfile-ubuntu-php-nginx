#!/bin/bash

service php${P_V}-fpm start && service nginx start

tail -f /var/log/nginx/error.log
