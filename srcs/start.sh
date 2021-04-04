#!/bin/bash

if [ $AUTOINDEX == true ]
then
    echo autoindex on
    rm -f /var/www/my_super_site/index.nginx-debian.html 
else
    echo autoindex off
    awk '!/autoindex/' /etc/nginx/conf.d/ssl.conf > /etc/nginx/conf.d/ssl.conf2
    mv /etc/nginx/conf.d/ssl.conf2  /etc/nginx/conf.d/ssl.conf
fi

# Setting up mariadb
service mysql start

mysql -u root -e "CREATE USER 'scarboni'@'localhost' IDENTIFIED BY 'pw';"
mysql -u root -e "CREATE DATABASE wordpress;"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'scarboni'@'localhost' IDENTIFIED BY 'pw';"
mysql -u root -e "FLUSH PRIVILEGES;" 

service php7.3-fpm start
nginx -t && nginx -g "daemon off;" -c /etc/nginx/nginx.conf
