#!bin/bash

#Update repository and Upgrade OS
sudo apt update
sudo apt upgrade -y

#Install and configure Docker
sudo apt install docker.io
sudo groupadd docker
sudo usermod -aG docker $USER

#Build and run simple web app on Docker

git clone https://github.com/jessie-txt/simple-webapp.git
cd simple-webapp
docker build . -t simple-webapp:latest
docker run -d -p 80:80 simple-webapp:latest