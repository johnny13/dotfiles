#!/usr/bin/env bash

taskList()
{
    taskName "TASK NAME"
    taskStatus "INFO" "PHP INSTALL"
    sudo apt update -y --show-progress
    sudo apt upgrade -y --show-progress
    lineBreak

    taskName "SETUP"
    taskStatus "HOME" "CREATE DIRECTORY"

    cd ~
    mkdir -p ./Developer
    cd ./Developer

    lineBreak

    taskName "SOURCES"
    taskStatus "ADD" "GITHUB & CHECKRA1N"
    addSources
    lineBreak

    taskName "INSTALL"
    taskStatus "GIT" "APT INSTALL"
    sudo apt install git wget curl build-essential software-properties-common xutils-dev dialog nano micro sassc
    lineBreak

    taskName "PHP-7 DEBIAN"
    taskStatus "GIT" "FETCHING REPO"
    git clone https://github.com/kasparsd/php-7-debian.git php7
    cd php7
    ./build.sh
    sudo ./install.sh
    sudo ln -s /usr/local/php7/bin/php /usr/local/bin/php
    lineBreak

    taskName "APACHE2"
    taskStatus "HTTP" "APACHE WEBSERVER INSTALL"
    addApache
    lineBreak

    taskName "Node.js"
    taskStatus "NVM" "NODE VERSION MANAGER"
    addNode
    lineBreak

    finishEcho "DEBIAN FUNCTIONS"
}

###
### INSTALL SECTIONS
###

addNode()
{
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.bashrc

    nvm install --lts
    taskStatus "CONFIRM" "NODE, NVM, NPM INSTALLED"

    nvm current
    npm --version

    taskStatus "YARN" "INSTALLING PACKAGE MANAGER"
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y  yarn

}

addApache()
{
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2

    sudo ufw app list
    sudo ufw allow 'Apache'
    sudo ufw status
    sudo ufw reload
    sudo ufw restart
    sudo systemctl status apache2
    apache2 --version
    sudo apt update -y
    # visit: 0.0.0.0

    if _hasCMD "xdg-open"; then
        echo "Visiting http://localhost to confirm Apache is working..."
        xdg-open "http://localhost"
    else
        echo "xdg-open is not installed. Please visit http://localhost to confirm Apache is working..."
        echo -e "You can also try just visiting this machines IP Address, which is: "
        echo ""
        echo "    $> hostname -I"
        echo ""
        hostname -I
        echo ""
        echo ""
    fi

    # Adjust Webroot Permissions
    sudo chmod -R 0775 /var/www/html/
}

addSources()
{
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

    sudo add-apt-repository universe

    sudo apt update
    sudo apt install gh
}

libraries()
{
    sudo  apt install gcc build-essential checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev wget openssl libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

    sudo apt install -y git curl unzip lsb-release apt-transport-https ca-certificates openssl openssh-server openssh-client openjdk-14-jdk openjdk-14-jre parted pastebinit qemu-kvm rsync shc ssh-import-id ssh-askpass-gnome ssl-cert sudo synaptic spacefm unrar vagrant xdotool xclip zip yadm android-file-transfer android-sdk-platform-tools-common ansiweather caca-utils cmake automake debconf dconf-cli dkms fo nt-manager font-viewer fontconfig ftp fuse gawk gettext ghostscript gparted gpart gpg htop iftop imagemagick jo

    sudo apt install -y openssl ssl-cert tcl-tls python-openssl mcrypt python3-m2crypto curl gnupg2 dirmngr git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev

    # python3 ruby sassc apache2 mysql-server php-cli php-mbstring xterm

    sudo apt autoremove
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove
}

##
## Run the main function
##

taskList
