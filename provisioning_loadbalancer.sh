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

#config nginx
sudo bash -c 'cat <<EOF > /etc/nginx/conf.d/nginx.conf
http{
 
    upstream finditgeek{
        baris method : round-robin
        server 10.10.10.30 max_fails=3 fail_timeout=30s;
        server 10.10.10.30 max_fails=3 fail_timeout=30s;
    }

    server {
        listen        443 ssl;
        ssl_certificate /etc/tls/cert.pem
        ssl_certificate_key /etc/tls/key.pem
        access_log /var/log/nginx/finditgeek-presentation_access_log;
        error_log /var/log/nginx/finditgeek-presentation_error_log;
        
        proxy_pass http://finditgeek:80
    }

    server {
        listen 80;
        access_log /var/log/nginx/finditgeek-presentation_access_log;
        error_log /var/log/nginx/finditgeek-presentation_error_log;
        
        return 301 https://10.10.10.10:443;

    }
}
EOF'