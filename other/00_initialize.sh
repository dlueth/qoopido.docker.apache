#!/bin/bash
mkdir -p /app/logs

if [[ ! -d /app/logs/apache2 ]]; then
	mv /var/log/apache2 /app/logs/apache2
else
	rm -rf /var/log/apache2
fi

ln -s /app/logs/apache2 /var/log/apache2
ln -s /app/config/apache2/apache2.conf /etc/apache2/apache2.conf
ln -s /app/config/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
ln -s /app/config/apache2/php5-fpm.conf /etc/apache2/conf-available/php5-fpm.conf
ln -s /app/config/php5/php.ini /etc/php5/fpm/php.ini
ln -s /app/htdocs /var/www/html

a2enconf php5-fpm
a2ensite 000-default.conf