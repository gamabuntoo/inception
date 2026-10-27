FROM debian:bookworm

# RUN apt-get update && apt-get install -y net-tools \
	# php php-fpm php-mbstring php-bcmath php-xml php-mysql \
	# php-common php-gd php-cli php-curl php-zip php-imagick php-ldap php-intl zip unzip wget curl git && apt-get clean

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl \
	php-mysql php-fpm zip unzip wget curl git mariadb-client gnupg ca-certificates && apt-get clean

RUN rm -rf /var/lib/apt/lists/*
# remove apt-get cache bcs it'll be useless until now
RUN mkdir -p /run/php && chown www-data:www-data /run/php

WORKDIR /var/www/html
RUN rm -rf *
#downloading php + wordpress from latest release + unzipping it
# RUN wget https://wordpress.org/latest.zip && unzip latest.zip && rm latest.zip
# RUN mv wordpress/* . && rm -rf wordpress

RUN chown -R www-data:www-data /var/www/html/
#install nginx openssl and update everything
RUN find /var/www/html/ -type d -exec chmod 755 {} \;
RUN find /var/www/html/ -type f -exec chmod 644 {} \;

RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf
#change socket to 9000

EXPOSE 9000

#bashscript to get phpfpm version
COPY conf/php.sh /usr/sbin/php.sh
RUN chmod 755 /usr/sbin/php.sh
#run phpfpm script
CMD ["/usr/sbin/php.sh"]

# FINIR WORDPRESS ATTENTION


#MARIADB A FAIRE MTN 
