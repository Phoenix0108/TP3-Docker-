#!/bin/sh
set -e
docker rm -f http script data 2>/dev/null || true
docker network create tp3network 2>/dev/null || true

docker build -t php-mysqli ./src

docker run -d \
  --name script \
  --network tp3network \
  -v "$(pwd)/app:/app" \
  php-mysqli

docker run -d \
  --name http \
  --network tp3network \
  -p 8080:80 \
  -v "$(pwd)/app:/app" \
  -v "$(pwd)/config/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

docker run -d \
  --name data \
  --network tp3network \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v "$(pwd)/config/data:/docker-entrypoint-initdb.d:ro" \
  mariadb:latest