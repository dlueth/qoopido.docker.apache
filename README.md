# Build container #
```
docker build -t mit/apache .
```

# Run container #
```
docker run -d -P -t -i -p 80:80 -p 443:443 \
	-v [local path to apache htdocs]:/app/htdocs \
	-v [local path to apache logs]:/app/logs \
	-v [local path to PHP sessions]:/app/sessions \
	-v [local path to config]:/app/config \
	--link mariadb:db \
	--name apache mit/apache
```

# Open shell in container #
```
docker exec -i -t "apache" /bin/bash
```

# Project specific configuration #
Any files under /app/config will be symlinked into the container filesystem beginning at the root directory. This can be used to, e.g., overwrite default php.ini configuration with a custom and project specific configuration. Be careful changing any of the default paths used for exposing shared directories (logs/sessions) though as these might break things.