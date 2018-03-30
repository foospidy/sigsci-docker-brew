#!/usr/bin/env bash

set -e

brew=$(which brew)
if [ -z "$brew" ];
then
    echo "Homebrew not found. Please install Homebrew."
    exit;
fi

docker=$(which docker)
if [ -z "$docker" ];
then
    echo "Docker not found. Installing docker..."
    brew install docker
fi

dockermachine=$(which docker-machine)
if [ -z "$dockermachine" ];
then
    echo "Docker-machine not found. Installing docker-machine."
    brew install docker-machine
fi

dockerimage=$(docker-machine ls | grep sigsci)
if [ "$?" != "0" ];
then
    echo "Sigsci docker image not found. Creating Docker image..."
    docker-machine create --driver virtualbox --virtualbox-disk-size 2048 --virtualbox-memory 1024 sigsci
fi

echo "Starting Signal Sciences Docker"

if [ -z "$SIGSCI_ACCESSKEYID" ];
then
    echo "Please set your SIGSCI_ACCESSKEYID"
    echo "e.g. export SIGSCI_ACCESSKEYID=<key>"
    exit;
fi

if [ -z "$SIGSCI_SECRETACCESSKEY" ];
then
    echo "Please set your SIGSCI_SECRETACCESSKEY"
    echo "e.g. export SIGSCI_SECRETACCESSKEY=<key>"
    exit;
fi

if [ -z "$SIGSCI_WEBAPP_HOST" ];
then
    SIGSCI_WEBAPP_HOST=$(ipconfig getifaddr en0)
fi

if [ -z "$SIGSCI_WEBAPP_PORT" ];
then
    SIGSCI_WEBAPP_PORT="8080"
fi

if [ -z "$SIGSCI_AGENT_PORT" ];
then
    SIGSCI_AGENT_PORT="80"
fi

eval "$(docker-machine env sigsci)"

docker build -t sigsci-agent:latest .

docker run \
    -i \
    -p "$SIGSCI_AGENT_PORT:80" \
    --add-host="my.mac.localhost:$SIGSCI_WEBAPP_HOST" \
    -e SIGSCI_ACCESSKEYID="$SIGSCI_ACCESSKEYID" \
    -e SIGSCI_SECRETACCESSKEY="$SIGSCI_SECRETACCESSKEY" \
    -e SIGSCI_REVERSE_PROXY="true" \
    -e SIGSCI_REVERSE_PROXY_LISTENER="0.0.0.0:80" \
    -e SIGSCI_REVERSE_PROXY_UPSTREAM="my.mac.localhost:$SIGSCI_WEBAPP_PORT" \
    -t sigsci-agent:latest
