#!/bin/sh

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -config localhost.conf

openssl rsa -in localhost.key -out localhost.key

docker build . -t test-local-https:v1

docker-compose up -d