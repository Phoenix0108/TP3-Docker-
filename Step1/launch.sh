#!/bin/sh
set -e
docker rm -f http script 2>/dev/null || true
docker network create tp3network 2>/dev/null || true

docker run -d \
  --name script \
  --network tp3network \
  -v "$(pwd)/app:/app" \
  php:8.2-fpm

docker run -d \
  --name http \
  --network tp3network \
  -p 8080:80 \
  -v "$(pwd)/app:/app" \
  -v "$(pwd)/config/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest
