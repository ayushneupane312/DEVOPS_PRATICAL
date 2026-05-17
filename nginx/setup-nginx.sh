#!/bin/bash
sudo apt update && sudo apt install -y nginx certbot python3-certbot-nginx
sudo cp nginx.conf /etc/nginx/sites-available/devops-app
sudo ln -sf /etc/nginx/sites-available/devops-app /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
echo "Nginx configured!"
# Uncomment to get SSL cert:
# sudo certbot --nginx -d example.com
