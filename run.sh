#!/bin/sh

docker-compose up -d
ngrok http 8080 --hostname ordina.ivo2u.org --region eu
docker-compose down -v
