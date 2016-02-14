#!/bin/bash

HOSTNAME=$(hostname)
INIT="/etc/apache2/initialize.sh"
FILE_KEY="/app/ssl/$HOSTNAME.key"
FILE_CRT="/app/ssl/$HOSTNAME.crt"

if [ -d /app/config/apache2 ]
then
	files=($(find /app/config/apache2 -type f))

	for source in "${files[@]}"
	do
		pattern="\.DS_Store"
		target=${source/\/app\/config\/apache2/\/etc\/apache2}

		if [[ ! $target =~ $pattern ]]; then
			if [[ -f $target ]]; then
				echo "    Removing \"$target\"" && rm -rf $target
			fi

			echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
		fi
	done
fi

if [ ! -f $FILE_KEY ]
then
	openssl req -x509 -nodes -days 36500 -newkey rsa:8192 -keyout $FILE_KEY -out $FILE_CRT -subj "/C=DE/ST=None/L=None/O=None/OU=None/CN=$HOSTNAME"
fi

mkdir -p /app/htdocs
mkdir -p /app/ssl
mkdir -p /app/logs/apache2

a2ensite -q 000-default.conf > /dev/null 2>&1

if [ -f $INIT ]
then
	 chmod +x $INIT && chmod 755 $INIT && eval $INIT;
fi