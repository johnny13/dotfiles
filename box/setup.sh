#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
         echo "Please run as root"
    exit 1
fi

# COLOR OPTIONS
BRED="\e[1;31m" # Red
BBLU="\e[1;34m" # Blue
BGRN="\e[1;32m" # Green
BCYN="\e[1;36m" # Cyan
BWHT="\e[1;37m" # White
BPUR="\e[1;35m" # Purple
BYLW="\e[1;33m" # Yellow
NORMAL="\e[0m"  # Text Reset

###
### UI FUNCTIONS
###

banner()
{
    echo -e "${BPUR}"
    cat <<EOF


                0000000..     .,-00000
                ||||^^||||  ,|||*^^^^*
                [[[,/[[[*   [[[
                XXXXXXx     XXX
                888b ^88bo, *88bo,__,o,
EOF
    echo -en "${BCYN}"
    cat <<EOF
  .--.      .--.      .--.      .--.      .--.
:::::.\::::::::.\::::::::.\::::::::.\::::::::.\::[ 0.13.1 ]
       '--'      '--'      '--'      '--'      '

EOF
    echo -e "${NORMAL}"
}

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
    sudo apt install git wget curl build-essential software-properties-common xutils-dev
    lineBreak

    taskName "PHP-7 DEBIAN"
    taskStatus "GIT" "FETCHING REPO"
    git clone https://github.com/kasparsd/php-7-debian.git php7
    cd php7
    ./build.sh
    sudo ./install.sh
    lineBreak

    taskName "APACHE2"
    taskStatus "HTTP" "APACHE WEBSERVER INSTALL"
    addApache
    lineBreak

    echo -e "\n${BGRN}\t━━━━━━▶ FINISHED!\n${NORMAL}"
    echo -e "\n"
}

taskName()
{
    echo -e "\t${BPUR}◼${BCYN} ${1} ${BWHT}❱❱ ${NORMAL}"
}

taskStatus()
{
    echo -e "\t${BCYN}━━━${BBLU}❪ ${BWHT}${1} ${BBLU}❫${BCYN}━━━━━${BPUR}[ ${BWHT}${2} ${BPUR}]${NORMAL}"
}

lineBreak()
{
    echo -e "\n\t${BYLW}•••••\t${BGRN}•••••\t${BBLU}•••••\t${BPUR}•••••\t${BRED}•••••\n${NORMAL}"
}

###
### INSTALL SECTIONS
###

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

    echo "Visiting http://localhost to confirm Apache is working..."
    xdg-open "http://localhost"

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

###
### RUN SCRIPT
###

banner
taskList
