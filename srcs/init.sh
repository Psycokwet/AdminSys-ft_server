#!/bin/sh
# Creating my_super_site directory
mkdir -p /var/www/my_super_site/

# installing non auto index
mv /var/www/html/index.nginx-debian.html /var/www/my_super_site

# Giving exec rights to user www-data
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Moving to /tmp/ to download and configure pma, wp, and nginx
cd tmp/

# Moving phpmyadmin configuration source file to proper destination
cp /var/www/my_super_site/phpmyadmin/config.sample.inc.php /var/www/my_super_site/phpmyadmin/config.inc.php

# mv phpmyadmin.inc.php /var/www/my_super_site/phpmyadmin/config.inc.php
mv php-info.php /var/www/my_super_site/php-info.php

# Moving nginx configuration into proper destination

mv ssl.conf /etc/nginx/conf.d/ssl.conf 
mv http.conf /etc/nginx/conf.d/http.conf 
rm -rf /var/www/html /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default


# https generating configuration certificate

 openssl req -new -newkey rsa:2048 -nodes \
     -out /etc/ssl/certs/my_super_site.csr \
     -keyout /etc/ssl/private/my_super_site.key \
     -subj "/C=DE/ST=0/L=0/O=0/CN=my_super_site"
 openssl x509 -req -in /etc/ssl/certs/my_super_site.csr -signkey /etc/ssl/private/my_super_site.key -out /etc/ssl/certs/my_super_site.crt


# Setting up mariadb
service mysql start

mysql -u root -e "CREATE USER 'scarboni'@'localhost' IDENTIFIED BY 'pw';"
mysql -u root -e "CREATE DATABASE wordpress;"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'scarboni'@'localhost' IDENTIFIED BY 'pw';"
mysql -u root -e "FLUSH PRIVILEGES;" 

service nginx start
service php7.3-fpm start
nginx -t
