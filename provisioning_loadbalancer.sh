#!bin/bash

#Update repository and upgrade OS
sudo apt update
sudo apt upgrade -y

#Install NGINX and unzip
sudo apt install nginx unzip -y

#Download necessary file
wget https://www-presentation.s3.ap-southeast-1.amazonaws.com/cert.zip
sudo mkdir /etc/tls
unzip cert.zip -d cert
sudo cp cert/* /etc/tls

#Configure NGINX
sudo bash -c 'cat <<EOF > /etc/nginx/conf.d/nginx.conf
upstream finditgeek {
    server 10.10.10.20:80 max_fails=3 fail_timeout=30s;
    server 10.10.10.30:80 max_fails=3 fail_timeout=30s;
}

server {
    listen 443 ssl;
    ssl_certificate     /etc/tls/cert.pem;
    ssl_certificate_key /etc/tls/key.pem;
    access_log /var/log/nginx/finditgeek-presentation_access_log;
    error_log /var/log/nginx/finditgeek-presentation_error_log;

    location / {
        proxy_pass http://finditgeek;
    }
}
EOF'

sudo systemctl restart nginx.service