#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

/*
 * Install docker community edition
 */
apt-cache policy docker-ce
apt-get install -y docker-ce

/*
 * Pull nginx image
 */
docker pull nginx:latest

/*
 * Run container with port mapping - host:container
 */
docker run -d -p 80:80 --name nginx nginx
