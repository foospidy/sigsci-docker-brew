# sigsci-docker-brew

Install and setup of a docker image for running Signal Sciences in reverse proxy mode on OSX

[![Build Status](https://travis-ci.org/foospidy/sigsci-docker-brew.svg?branch=master)](https://travis-ci.org/foospidy/sigsci-docker-brew)

### Dependencies

Before running, make sure you have the follwing tools installed on your Mac.

- [Virutalbox](https://www.virtualbox.org/wiki/Downloads)
- [Homebrew](https://brew.sh/)

### Instructions

1. Export your Signal Sciences agent keys to environment variables
    - `$ export SIGSCI_ACCESSKEYID=<key>`
    - `$ export SIGSCI_SECRETACCESSKEY=<key>`
2. Run `./sigsci_osx.sh`

This script will install docker and docker-machine if you don't already have it installed. By defualt it will start a docker container with the agent in reverse proxy mode listening on port 80, and proxy connections to port 8080 (the web app running on your Mac).

Optionally, you can adjust configuration with the following variables:

- SIGSCI_PORT - this is the port the agent will listen on.
    - Example: `export SIGSCI_PORT=8080`
- SIGSCI_WEBAPP_HOST - this is the ip address of the host running your web application.
    - Example: `export SIGSCI_WEBAPP_HOST=192.168.1.5`
- SIGSCI_WEBAPP_PORT - this is the port your web application is listening on.
    - Example: `export SIGSCI_WEBAPP_PORT=8085`


When the docker container starts you will see the agent start up and the agent logs. You can press ctrl+c to stop the agent and the container.
