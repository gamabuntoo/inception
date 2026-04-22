FROM debian:bookworm

RUN apt-get update && apt-get install -y openssl nginx
#install nginx openssl and update everything
RUN rm -rf /var/lib/apt/lists/*
# remove apt-get cache bcs it'll be useless until now

# create nginx ssl file
RUN mkdir -p /etc/nginx/ssl


# create a self 
RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key \
	-out /etc/nginx/ssl/nginx-selfsigned.crt -subj \
	"/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42/CN=gule-bat.42.fr/emailAddress=gule-bat@42paris.fr"

RUN chmod 644 /etc/nginx/ssl/nginx-selfsigned.crt
RUN chmod 600 /etc/nginx/ssl/nginx-selfsigned.key

COPY conf/nginx.conf /etc/nginx/nginx.conf

# open the output port to get infos outside of the container
EXPOSE 443

# start running nginx in foreground
CMD ["nginx", "-g", "daemon off;"]