#!/bin/sh
sudo apt update
# Download + install MediaWiki
sudo mkdir -p /var/www/
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.11.tar.gz
sudo tar xvf mediawiki-1.35.11.tar.gz -C /var/www/
mv /var/www/mediawiki-1.35.11 /var/www/mediawiki
# PHP install
sudo apt -y install php7.4-mbstring php7.4-xml php7.4-fpm php7.4-json php7.4-mysql php7.4-curl php7.4-intl php7.4-gd php7.4-mbstring texlive imagemagick
sudo apt -y install mariadb-server mariadb-client composer nginx
cd /var/www/mediawiki/ | sudo composer install --no-dev
#MariaDB config
echo "CREATE DATABASE my_wiki;" | mysql
echo "CREATE USER 'wikiuser'@'localhost' IDENTIFIED BY 'database_password';" | mysql
echo "GRANT ALL PRIVILEGES ON my_wiki.* TO 'wikiuser'@'localhost' WITH GRANT OPTION;" | mysql
# Nginx SSL + Config
mkdir /etc/nginx/certs
cp fermolaev.devops.rebrain.srwx.net.key /etc/nginx/certs/
cp fullchain_fermolaev.devops.rebrain.srwx.net /etc/nginx/certs/
cp default /etc/nginx/sites-available/
systemctl restart nginx
