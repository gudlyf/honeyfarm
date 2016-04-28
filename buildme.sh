#!/bin/bash

# The below is relevant for those using with docker-machine, at least on MacOS

echo "Copying latest relevant docker-machine keys..."

cp -f $DOCKER_CERT_PATH/ca.pem ./keys
cp -f $DOCKER_CERT_PATH/server-key.pem ./keys/key.pem
cp -f $DOCKER_CERT_PATH/server.pem ./keys/cert.pem

echo "Building container..."

docker build --tag gudlyf/honeyfarm .
