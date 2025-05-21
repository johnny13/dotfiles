#!/usr/bin/env bash
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
sudo apt update
echo ""
echo " You can now install php however you want."
echo " > sudo apt install php8.3 php8.3-cli php8.3-{bz2,curl,mbstring,intl}"
echo ""
echo ""

# https://php.watch/articles/php-8.3-install-upgrade-on-debian-ubuntu#php83-debian-quick
# Install FPM OR Apache module
# sudo apt install php8.3-fpm
# OR
# sudo apt install libapache2-mod-php8.3