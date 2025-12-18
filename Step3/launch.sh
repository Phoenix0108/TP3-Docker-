#!/bin/sh
set -e
docker rm -f http script data 2>/dev/null || true
docker compose down 2>/dev/null || true

docker compose up -d --build