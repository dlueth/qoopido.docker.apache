# Build container #
docker build -t mit/apache .

# Run container #
docker run -d -P -t -i -p 80:80 -p 443:443 && \
	-v [local path to apache htdocs]:/app/htdocs && \
	-v [local path to apache logs]:/app/logs && \
	-v [local path to apache config]:/app/config/php5 && \
	-v [local path to php config]:/app/config/php5 && \
	--link mariadb:db && \
	--name apache mit/apache

# Open shell in container #
docker exec -i -t "apache" /bin/bash

# Allowed configuration files #
- Apache2
	- apache2.conf => /etc/apache2/apache2.conf
	- 000-default.conf => /etc/apache2/sites-available/000-default.conf
	- php5-fpm.conf => /etc/apache2/conf-available/php5-fpm.conf
- PHP5
	- php.ini => /etc/php5/fpm/php.ini