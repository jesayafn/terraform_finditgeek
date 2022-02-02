#!bin/bash

#Update repository and Upgrade OS
sudo apt update
sudo apt upgrade -y

#Install and configure Docker
sudo apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
sudo usermod -aG docker $USER

#Build and run simple web app on Docker
git clone https://github.com/jessie-txt/simple-webapp.git
cd simple-webapp
docker build . -t simple-webapp:latest
docker run -d -p 80:80 simple-webapp:latest