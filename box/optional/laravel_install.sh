#!/bin/bash

#
# UPDATE / UPGRADE
#

echo "--------------- Installing Composer Globally";

# Install Necessary Packages
#sudo apt-get -y install curl git zip

# Install Composer
if [ ! -f /usr/local/bin/composer ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
fi

echo "--------------- Installing Laravel 5";

# Install Necessary Packages
#sudo apt-get -y install curl git zip

# Install Laravel
composer global require "laravel/installer"

git clone -b master --single-branch https://github.com/laravel/laravel.git /var/www/html/laravel

# Finalize Laravel install
echo
echo "LARAVEL SETUP!"
cd /var/www/html/laravel
composer install --no-dev
npm install
cp .env.example .env
php artisan key:generate

# Change permision Laravel files
chown www-data:www-data /var/www/html/laravel -R
