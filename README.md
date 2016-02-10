# Build container #
```
docker build -t qoopido/apache2:1.0.4 .
```

# Run container manually ... #
```
docker run -d -P -t -i -p 80:80 -p 443:443 \
	-h [hostname]
	-v [local path to apache htdocs]:/app/htdocs \
	-v [local path to ssl certificates]:/app/ssl \
	-v [local path to logs]:/app/logs \
	-v [local path to config]:/app/config \
	--name apache qoopido/apache2
```

# ... or use docker-compose #
```
apache:
  image: qoopido/apache2
  hostname: [hostname]
  ports:
   - "80:80"
   - "443:443"
  volumes:
   - ./htdocs:/app/htdocs
   - ./ssl:/app/ssl
   - ./logs:/app/logs
   - ./config:/app/config
```

# Open shell #
```
docker exec -i -t "apache" /bin/bash
```

# Project specific configuration #
Any files under ```/app/config/apache2``` will be symlinked into the container's filesystem beginning at ```/etc/apache2```. This can be used to overwrite the container's default site configuration with a custom, project specific configuration to (e.g.) include php fpm fastCGI proxy (which requires linking a php fpm container).

If you need a custom shell script to be run on start (e.g. to set symlinks) you can do so by creating the file ```/app/config/apache2/initialize.sh```.

SSL certificates will be auto-generated per hostname if no key/crt file can be found in /app/ssl/[hostname].[key|crt]