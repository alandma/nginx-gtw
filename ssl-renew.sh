#!/bin/bash
COMPOSE="/usr/local/bin/docker-compose --ansi never"
DOCKER="/usr/bin/docker"
DIR=$PWD

cd ${DIR}
$COMPOSE run certbot renew && $COMPOSE kill -s SIGHUP gtw-ngx
$DOCKER system prune -af
