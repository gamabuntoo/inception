FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	mariadb-server mariadb-client

	
COPY conf/msql.sh	/etc/mysql.sh
	
RUN sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
	
RUN chmod +x /etc/mysql.sh

EXPOSE 3306

CMD ["/etc/mysql.sh"]