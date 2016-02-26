# recommended directory structure #
Like with my other containers I encourage you to follow a unified directory structure approach to keep things simple & maintainable, e.g.:

```
project root
  - docker_compose.yaml
  - config
    - apache2
      - initialize.sh (if needed)
      - sites-enabled
        - ...
  - htdocs
  - ssl
  - logs
```

# Example docker-compose.yaml #
```
web:
  image: qoopido/apache2:latest
  hostname: [hostname]
  ports:
   - "80:80"
   - "8080:8080"
   - "443:443"
  volumes:
   - ./config:/app/config
   - ./htdocs:/app/htdocs
   - ./ssl:/app/ssl
   - ./logs:/app/logs
```

# Or start container manually #
```
docker run -d -P -t -i -p 80:80 -p 443:443 \
	-h [hostname]
	-v [local path to config]:/app/config \
	-v [local path to htdocs]:/app/htdocs \
	-v [local path to ssl certificates]:/app/ssl \
	-v [local path to logs]:/app/logs \
	--name web qoopido/apache2:latest
```

# Configuration #
The container comes with a default configuration for Apache2 under ```/etc/apache2/apache2.conf```. The container comes with a default site-configuration for ```/app/htdocs``` for SSL and non-SSL.

Any files mounted under ```/app/config/apache2``` will be symlinked into the container's filesystem beginning at ```/etc/apache2```. This may be used to overwrite the container's default nginx configuration with a custom, project specific configuration to (e.g.) include php fpm fastCGI proxy (which requires linking a php fpm container). The current hostname is provided as an environment variable for Apache 2 so that ```${HOSTNAME}``` may be used in any Apache configuration.

If you need a custom shell script to be run on start (e.g. to set symlinks) you can do so by creating the file ```/app/config/apache2/initialize.sh```.

SSL certificates will be auto-generated per hostname if no key/crt file can be found in ```/app/ssl/[hostname].[key|crt]```.