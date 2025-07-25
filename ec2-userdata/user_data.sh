#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html