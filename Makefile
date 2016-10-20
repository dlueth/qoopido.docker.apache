tag?=develop

build:
	docker build --no-cache=true -t qoopido/apache2:${tag} .