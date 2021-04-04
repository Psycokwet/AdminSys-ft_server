#!/bin/sh

if [ $AUTOINDEX == true ]
then
    echo autoindex on
    rm /var/www/my_super_site/index.nginx-debian.html 
else
    echo autoindex off
    awk '!/autoindex/' /etc/nginx/conf.d/ssl.conf > /etc/nginx/conf.d/ssl.conf2
    mv /etc/nginx/conf.d/ssl.conf2  /etc/nginx/conf.d/ssl.conf
fi