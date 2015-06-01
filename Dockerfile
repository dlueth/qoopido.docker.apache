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

# alter package sources
	RUN rm -rf /etc/apt/sources.list
	ADD other/sources.list /etc/apt/sources.list

# install packages
	RUN apt-get update && \
		apt-get install -qy apache2-mpm-event \
			libapache2-mod-fastcgi \
			php5-common \
			php5-json \
			php5-gd \
			php5-curl \
			php5-fpm \
			php5-mcrypt \
			php5-mysqlnd \
			php5-sqlite \
			php5-apcu \
			language-pack-de-base \
			language-pack-de

# alter configuration files & directories
	RUN rm -rf /app/config/apache2 && \
		rm -rf /app/config/php5 && \
		rm -rf /app/htdocs && \
		rm -rf /app/logs && \
		rm -rf /var/www/html && \
		rm -rf /etc/apache2/apache2.conf && \
		rm -rf /etc/apache2/conf-available/php5-fpm.conf && \
		rm -rf /etc/apache2/sites-available/000-default.conf && \
		rm -rf /etc/php5/fpm/php.ini
	ADD app/config/apache2 /app/config/apache2
	ADD app/config/php5 /app/config/php5
	ADD app/htdocs/ /app/htdocs
	
# enable apache configuration
	RUN a2enmod actions && \
		a2enmod rewrite && \
		a2enmod headers && \
		a2enmod expires

# add run-scripts
	ADD other/00_initialize.sh /etc/my_init.d/00_initialize.sh
	ADD other/01_start_apache2.sh /etc/my_init.d/01_start_apache2.sh
	ADD other/02_start_php5-fpm.sh /etc/my_init.d/02_start_php5-fpm.sh
	RUN chmod +x /etc/my_init.d/*.sh && \
		chmod 755 /etc/my_init.d/*.sh

# cleanup
	RUN apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# finalize
	VOLUME ["/app/htdocs", "/app/config/apache2", "/app/config/php5", "/app/logs"]
	EXPOSE 80
	EXPOSE 443
