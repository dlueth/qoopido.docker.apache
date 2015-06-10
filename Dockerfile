FROM phusion/baseimage:latest
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# based on dgraziotin/docker-osx-lamp
	ENV DOCKER_USER_ID 501 
	ENV DOCKER_USER_GID 20
	ENV BOOT2DOCKER_ID 1000
	ENV BOOT2DOCKER_GID 50

# Tweaks to give Apache/PHP write permissions to the app
	RUN usermod -u ${BOOT2DOCKER_ID} www-data && \
    	usermod -G staff www-data && \
    	groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && \
    	groupmod -g ${BOOT2DOCKER_GID} staff

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
		apt-get install -qy apache2-mpm-event
		
# enable apache2 modules
	RUN a2enmod rewrite && \
		a2enmod headers && \
		a2enmod expires && \
		a2enmod proxy_fcgi && \
		a2enmod ssl
		
# add default /app directory
	ADD app /app
	RUN mkdir -p /app/htdocs && \
		mkdir -p /app/logs/apache2 && \
		rm -rf /var/www/html /var/log/apache2

# cleanup
	RUN apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /configure.sh

# finalize
	VOLUME ["/app/htdocs", "/app/logs", "/app/config"]
	EXPOSE 80
	EXPOSE 443
