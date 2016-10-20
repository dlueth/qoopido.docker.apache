#!/bin/bash

mkdir -p /app/htdocs
mkdir -p /app/data/certificates
mkdir -p /app/data/logs
mkdir -p /app/config

HOSTNAME=$(hostname)
FILE_KEY="/app/data/certificates/$HOSTNAME.key"
FILE_CRT="/app/data/certificates/$HOSTNAME.crt"
FILES=($(find /app/config -type f \( -not -name ".DS_Store" \)))

for source in "${FILES[@]}"
do
	target=${source/\/app\/config/etc\/apache2}

	if [[ -f $target ]]; then
		echo "    Removing \"$target\"" && rm -rf $target
	fi

	echo "    Linking \"$source\" to \"$target\"" && mkdir -p $(dirname "${target}") && ln -s $source $target
done

if [ ! -f $FILE_KEY ]
then
	openssl req -x509 -nodes -days 36500 -newkey rsa:8192 -keyout $FILE_KEY -out $FILE_CRT -subj "/C=DE/ST=None/L=None/O=None/OU=None/CN=$HOSTNAME"
fi