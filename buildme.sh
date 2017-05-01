#!/bin/bash

# The below is relevant for those using with docker-machine, at least on MacOS

echo "Copying latest relevant docker-machine keys..."

cp -f $DOCKER_CERT_PATH/ca.pem ./keys
cp -f $DOCKER_CERT_PATH/server-key.pem ./keys/key.pem
cp -f $DOCKER_CERT_PATH/server.pem ./keys/cert.pem

echo "Building containers..."

docker build -f ./Dockerfile-entrypoint --tag honeyfarm/entrypoint .
docker build -f ./Dockerfile-ssh --tag honeyfarm/ssh .
#docker build -f ./Dockerfile-mysql --tag honeyfarm/mysql .
