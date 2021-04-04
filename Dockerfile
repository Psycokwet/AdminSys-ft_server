# OS
FROM debian:buster

# USER INFOS
MAINTAINER Sophie Carboni <scarboni@student.42.fr>

# ESSENTIALS
RUN apt update --fix-missing && \
	apt-get install  wget -yq
	#apt-get install -y procps && \
	#apt-get install -y vim

# EMP (nginx - mysql - php)
RUN apt-get install -y nginx && \
	apt-get install -y mariadb-server && \
	apt-get -yq install php php-fpm php-mysql  && \
	apt-get -yq install php-mbstring  && \
	apt-get -yq install php-zip && \
	apt-get -yq install php-gd 

RUN mkdir -pv /var/www/my_super_site/phpmyadmin /etc/nginx/conf.d/
COPY srcs/ssl.conf /etc/nginx/conf.d/ssl.conf
COPY srcs/http.conf /etc/nginx/conf.d/http.conf

# SSL configuration
RUN openssl req -new -newkey rsa:2048 -nodes \
     -out /etc/ssl/certs/my_super_site.csr \
     -keyout /etc/ssl/private/my_super_site.key \
     -subj "/C=DE/ST=0/L=0/O=0/CN=my_super_site"
RUN openssl x509 -req -in /etc/ssl/certs/my_super_site.csr -signkey /etc/ssl/private/my_super_site.key -out /etc/ssl/certs/my_super_site.crt


WORKDIR /root
# PHP MY ADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz -O pma.tar.gz && \
	cd /var/www/my_super_site/phpmyadmin && \
	tar -xvf /root/pma.tar.gz

COPY srcs/start.sh /root/start.sh

# Copy source files into container
COPY srcs/* /tmp/

# Start initialization script
ENV AUTOINDEX true
CMD /root/start.sh
