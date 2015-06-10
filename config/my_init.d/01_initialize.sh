#!/bin/bash

files=($(find /app/config -type f))

for source in "${files[@]}" 
do
	pattern="\.DS_Store"
	target=${source/\/app\/config/\/etc}
	
	if [[ ! $target =~ $pattern ]]; then
		if [[ -f $target ]]; then
			echo "    Removing \"$target\"" && rm -rf $target
		fi
		
		echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
	fi
done

mkdir -p /app/htdocs
mkdir -p /app/logs/apache2

a2ensite -q 000-default.conf > /dev/null 2>&1