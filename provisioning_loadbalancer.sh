#!bin/bash

#Update repository and upgrade OS
sudo apt update
sudo apt upgrade -y

#Install NGINX and unzip
sudo apt install nginx unzip -y

#Download necessary file
wget https://www-presentation.s3.ap-southeast-1.amazonaws.com/cert.zip?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEB8aDmFwLXNvdXRoZWFzdC0xIkcwRQIhAJUYUO6DOn4Fv6Eti00If4vJIKbg9VG9AaC%2BirzwLDQPAiB48UISlrZ%2BRuj6RbfWnXyXvNfJjt6WIj%2F3%2FauiWN6vRyrkAghYEAEaDDIxNDYzNTM0MzY0OSIMn16kRhmLMWss%2FNdWKsEC99ny48hTWpejURuSFfXxCr82%2BQSHpjMCayb4Mgdmk0aghsqRzbR0YRiBhtgc8GTf89cnWLGyH5VOu8E2lGKVxAOL%2BCijMapudGsQp7honMx7XNL%2BikAgcXSoJdxgjGLNC9%2BTNMvW1UIQ6UtkBUY1OdYGmZvOI8j0JhZiaoyUm%2BKdVWSWyvnAT8%2BVbgzei7OLYe9dMkOdnVOYtV%2Bf4cuIg%2BlT0nij3ETjDdXGwI0Z7noX2chEOXIBz1yUaVy1rimLxem8g%2FIcObldhGRDReO2VZmNV5TNBaRq3%2FRYD95gL0sPdp31BiiYA1L9deWUIUR%2F%2FugdCoaVBGYNAmN8UNb7f1F41DxJ4T1HSv1%2FT41y7TYGyySCy36Wg2i7%2BpTRNxstsW958dyePPS76XFMmRp75Ewvux1reZgSRdeuizfi0VVtMJjR6I8GOrMCH8%2FBNKDae5tmTLnY9YuFE84eNl5zFp8d2JeROLm04t4EYjbiqFMiYTAZy8agQP7I%2Fc7QhGbgTG1Hfum%2FF5MUy54DG8JC8wM%2FYCvE%2FNS8w1anLY2%2FoQ3%2FmOFq3yLBH7nx3f9MgkBqvD6Zsd8yOamE7figSYl0bT3YoxH%2Bb6Gz3lrcWdfSuofi4t46s7FeEqpni1ehB1LNQzhgeXZnJyLqWC2BPFjuJ0WVLYhfSDmTcU%2FagC6nojUls%2F2LM4Vl7C9cBPFpTV%2BYBuRNp%2BD3NzImmQhegcwzrP4Zz8WbpXWLmH0T1cS8VTrgBq%2BPD97yfCICR5j9gS4Enpm7V3rN3nyIdut3mhyelGyqvN2XPgjB%2FVQxbP%2B8cHh0kjLQT%2FcktPCZTMBENLk%2B3ox5FeZtO4bVGmu17g%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220202T070945Z&X-Amz-SignedHeaders=host&X-Amz-Expires=518400&X-Amz-Credential=ASIATD6KDN4QZLU33LDQ%2F20220202%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Signature=6fe1690af993acb977d89d8ac0fbced76289cad13ebcd6ebc2bea8b76aa28a37
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
 
        location / {
            proxy_pass http://finditgeek:80
        }
    }

    server {
        listen 80;
        access_log /var/log/nginx/finditgeek-presentation_access_log;
        error_log /var/log/nginx/finditgeek-presentation_error_log;
 
        location / {
            return 301 https://$host$request_uri;
        }
    }
}
EOF'