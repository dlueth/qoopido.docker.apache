#!/bin/bash

files=($(find /app/config -type f))

for path in "${files[@]}"
do
	pattern="\.DS_Store"
	source=${path/\./}
	target=${path/\/app\/config/}
	
	if [[ ! $target =~ $pattern ]]; then
		if [[ -f $target ]]; then
			echo "[remove] \"$target\"" && rm -rf $target
		fi
		
		echo "[link] \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
	fi
done

rm -rf /var/log/apache2
ln -s /app/logs/apache2 /var/log/apache2

rm -rf /var/www/html
ln -s /app/htdocs /var/www/html

a2enconf php5-fpm
a2ensite 000-default.conf

service apache2 start
service php5-fpm start