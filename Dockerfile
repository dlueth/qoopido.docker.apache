FROM phusion/baseimage:latest
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# configure defaults
	ADD configure.sh /configure.sh
	ADD config /config
	RUN chmod +x /configure.sh && \
		chmod 755 /configure.sh
	RUN /configure.sh && \
		chmod +x /etc/my_init.d/*.sh && \
		chmod 755 /etc/my_init.d/*.sh && \
		chmod +x /etc/service/apache2/run && \
		chmod 755 /etc/service/apache2/run
	
# install packages
	RUN apt-get update && \
		apt-get -qy upgrade && \
    	apt-get -qy dist-upgrade && \
		apt-get install -qy apache2

# enable apache2 modules
	RUN a2enmod rewrite && \
		a2enmod headers && \
		a2enmod expires && \
		a2enmod ssl && \
		a2enmod proxy && \
		a2enmod proxy_fcgi && \
        a2enmod proxy_balancer && \
        a2enmod proxy_http

# add default /app directory
	ADD app /app
	RUN mkdir -p /app/htdocs && \
		mkdir -p /app/data/certificates && \
		mkdir -p /app/data/logs && \
		mkdir -p /app/config && \
		rm -rf /var/www/html /var/log/apache2

# cleanup
	RUN apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /configure.sh

# finalize
	VOLUME ["/app/htdocs", "/app/data", "/app/config"]
	EXPOSE 80
	EXPOSE 8080
	EXPOSE 443
