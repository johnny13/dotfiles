#!/usr/bin/env bash

PHPVER="8.1"

sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg

sudo apt update

sudo apt install -y "php${PHPVER} php${PHPVER}-curl php${PHPVER}-gd php${PHPVER}-intl php${PHPVER}-mbstring php${PHPVER}-mysql php${PHPVER}-opcache php${PHPVER}-sqlite3 php${PHPVER}-xml php${PHPVER}-zip"
