#!/bin/bash

files=($(find /app/config -type f))

for source in "${files[@]}"
do
	pattern="\.DS_Store"
	target=${source/\/app\/config/}
	
	if [[ ! $target =~ $pattern ]]; then
		if [[ -f $target ]]; then
			echo "[remove] \"$target\"" && rm -rf $target
		fi
		
		echo "[link] \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
	fi
done

mkdir -p /app/htdocs
mkdir -p /app/sessions
mkdir -p /app/logs/apache2
mkdir -p /app/logs/php5
rm -rf /var/www/html
rm -rf /var/log/apache2
rm -rf /var/log/php5-fpm.log
touch /app/logs/php5/php5-fpm.log
ln -s /app/htdocs /var/www/html
ln -s /app/logs/apache2 /var/log/apache2
ln -s /app/logs/php5/php5-fpm.log /var/log/php5-fpm.log

a2enconf php5-fpm
a2ensite 000-default.conf

service apache2 start
service php5-fpm start