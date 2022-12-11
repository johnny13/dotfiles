#!/usr/bin/env bash

taskList()
{
    PMSG "INFO" "SETUP SYSTEM UPDATE & UPGRADE"
    miniLibs
    ruleln "-" 60

    PMSG "INFO" "SETUP HOME DIRECTORY"
    cd ~
    mkdir -p ./Developer
    cd ./Developer
    ruleln "-" 60
}

packageTasks()
{
    PMSG "INFO" "INSTALL APT PACKAGE INSTALLER"
    sleep 1
    c_question "Do you want to install base packages? [y/n]"
    read apt_answer
    case "$apt_answer" in
        y | Y | yes | Yes)
            c_success "Installing packages..."
            libraries
            ;;
        n | N | no | No)
            c_warning "Skipping package installation"
            ;;
        *)
            c_warning "Please respond with yes or no"
            ;;
    esac
    sleep 2
    ruleln "-" 60
}

SSHTasks()
{
    PMSG "INFO" "INSTALL SSH SECURE SETUP"
    sleep 1
    c_question "Do you want to install base packages? [y/n]"
    read apt_answer
    case "$apt_answer" in
        y | Y | yes | Yes)
            c_success "Installing packages..."
            install_ssh
            ;;
        n | N | no | No)
            c_warning "Skipping package installation"
            ;;
        *)
            c_warning "Please respond with yes or no"
            ;;
    esac
    sleep 2
    ruleln "-" 60
}

EXTRATasks()
{
    PMSG "INFO" "INSTALL PHP APACHE NODE.JS"
    sleep 1
    c_question "Do you want to continue with Code & Webserver Tasks? [y/n]"
    read apt_answer
    case "$apt_answer" in
        y | Y | yes | Yes)
            c_success "Running Code & Webserver Tasks"
            extraTasks
            ;;
        n | N | no | No)
            c_warning "Skipping Code & Webserver Tasks"
            ;;
        *)
            c_warning "Please respond with yes or no"
            ;;
    esac
    sleep 2
    ruleln "-" 60
}

devPackageTasks()
{
    PMSG "INFO" "DEV PACKAGE INSTALLER"
    sleep 1
    c_question "Do you want to install developer packages? [y/n]"
    read apt_answer
    case "$apt_answer" in
        y | Y | yes | Yes)
            c_success "Installing development packages..."
            devLibraries
            ;;
        n | N | no | No)
            c_warning "Skipping development package installation"
            ;;
        *)
            c_warning "Please respond with yes or no"
            ;;
    esac
    sleep 2
    ruleln "-" 60
}

extraTasks()
{
    PMSG "INFO" "GITHUB GH CLI TOOL"
    addGHSources
    ruleln "-" 60

    PMSG "INFO" "APACHE2 WEBSERVER INSTALL"
    addApache
    ruleln "-" 60

    PMSG "INFO" "PHP-7 DEBIAN FETCHING REPO"
    git clone https://github.com/kasparsd/php-7-debian.git php7
    cd php7
    ./build.sh
    sudo ./install.sh
    sudo ln -s /usr/local/php7/bin/php /usr/local/bin/php
    ruleln "-" 60

    PMSG "INFO" "Node.js NVM NODE VERSION MANAGER"
    addNode
    ruleln "-" 60

    finishEcho "DEBIAN FUNCTIONS"
}

ppaTask()
{
    PMSG "INFO" "ADD SOURCES"
    sleep 1
    PMSG "INFO" "ADD PPA REPOS FOR GIT, DOCKER, NGINX ETC"
    sleep 1
    c_question "Do you want to add the PPAs? [y/n]"
    read ppa_answer
    case "$ppa_answer" in
        y | Y | yes | Yes)
            c_hilight "Adding PPAs..."
            add_ppas
            c_success "PPA list is updated!"
            ;;
        n | N | no | No)
            c_error "Skipping adding PPAs..."
            ;;
        *)
            c_warning "Please respond with yes or no..."
            ;;
    esac

    ruleln "-" 60
    sleep 2
}

###
### INSTALL SECTIONS
###

addNode()
{
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.bashrc

    nvm install --lts
    PMSG "INFO" "NODE, NVM, NPM INSTALLED"

    nvm current
    npm --version

    PMSG "INFO" "INSTALLING YARN PACKAGE MANAGER"
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update -y && sudo apt install -y yarn

}

addApache()
{
    sudo apt install -y apache2 ufw
    sudo ufw enable
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
        echo ""
        echo "  NOTE: xdg-open is not installed. Please visit http://localhost to confirm Apache is working..."
        echo "  You can also try just visiting this machines IP Address, which is: "
        echo ""
        echo "    $> hostname -I"
        echo "  Attempting to run hostname now: "
        hostname -I
        echo ""

    fi

    # Adjust Webroot Permissions
    sudo chmod -R 0775 /var/www/html/
}

addGHSources()
{
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

    sudo add-apt-repository universe

    sudo apt update -y
    sudo apt install -y gh
}

# Quickly install minimum amount of packages to make things work
miniLibs()
{
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -f
    sudo apt autoremove -y

    sudo apt install -y git ufw wget curl sudo gcc build-essential software-properties-common unzip
}

libraries()
{
    cd ~
    cd ./Developer

    wget -O ./packages.txt https://github.com/johnny13/dotfiles/raw/main/box/Debian/packages.txt

    ##	Looks for a list of default packages to install
    if [ -f "./packages.txt" ]; then
        c_success "Found Packages list. Installing..."
        for i in $(cat ./packages.txt); do
            if ! dpkg-query -W -f='${Status} ${Version}\n' ${i} | grep "^install ok" >/dev/null; then
                c_install "Installing package ${i} "
                sudo apt-get install -y ${i}
            else
                c_success "Package ${i} is already installed. Skipping..."
            fi
        done
    else
        c_error "No Packages file found. Skipping package installation..."
    fi

    # sudo apt install -y xutils-dev dialog nano micro sassc  checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev openssl libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

    # sudo apt install -y lsb-release apt-transport-https ca-certificates openssl openssh-server openssh-client openjdk-14-jdk openjdk-14-jre parted pastebinit qemu-kvm rsync shc ssh-import-id ssh-askpass-gnome ssl-cert synaptic spacefm unrar vagrant xdotool xclip zip yadm android-file-transfer android-sdk-platform-tools-common ansiweather caca-utils cmake automake debconf dconf-cli dkms fo nt-manager font-viewer fontconfig ftp fuse gawk gettext ghostscript gparted gpart gpg htop iftop imagemagick jo

    # sudo apt install -y tcl-tls python-openssl mcrypt python3-m2crypto gnupg2 dirmngr git-core libreadline-dev libyaml-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev

    # python3 ruby sassc apache2 mysql-server php-cli php-mbstring xterm

    sudo apt update -y && sudo apt upgrade -y
    sudo apt autoremove -y
}

devLibraries()
{
    cd ~
    cd ./Developer

    wget -O ./dev_packages.txt https://github.com/johnny13/dotfiles/raw/main/box/Debian/dev_packages.txt

    ##	Looks for a list of default packages to install
    if [ -f "./dev_packages.txt" ]; then
        c_success "Found DEV Packages list. Installing..."
        for i in $(cat ./dev_packages.txt); do
            if ! dpkg-query -W -f='${Status} ${Version}\n' ${i} | grep "^install ok" >/dev/null; then
                c_install "Installing DEV package ${i} "
                sudo apt-get install -y ${i}
            else
                c_success "DEV Package ${i} is already installed. Skipping..."
            fi
        done
    else
        c_error "No DEV Packages file found. Skipping DEV package installation..."
    fi

    sudo apt update -y && sudo apt upgrade -y
    sudo apt autoremove -y
}

function add_ppas()
                    {
    ##	Git
    sudo add-apt-repository ppa:git-core/ppa -y
    ##	Gimp
    sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y
    ## OpenJDK
    sudo add-apt-repository ppa:openjdk-r/ppa -y
    ##	Github
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    ##	NGINX
    sudo add-apt-repository ppa:ondrej/nginx -y
    ##	PostGreSQL
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    ##	pgAdmin
    curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
    sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
    ##	Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ##	Google Cloud SDK
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list'
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    ##	Terminator
    sudo add-apt-repository ppa:mattrose/terminator -y
    ##	Neofetch
    sudo add-apt-repository ppa:dawidd0811/neofetch -y
    ##	Ubuntu Universe
    sudo add-apt-repository universe -y
    ##	Heroku
    echo "deb https://cli-assets.heroku.com/apt ./" >/etc/apt/sources.list.d/heroku.list
    curl https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
}

function update_system()
                         {
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -f
    sudo apt autoremove -y
}

install_ssh()
              {
    ##	Removes default SSH and re-installs it, then starts the service
    sudo apt remove -y openssh-server
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
    sudo service ssh start
    eval "$(ssh-agent -s)"
    ##	Modify firewall rules to allow SSH through
    sudo ufw allow ssh
    sudo ufw enable
    sudo ufw status
    ##	Looks for config and HOSTS files, then symlinks them
    if [ -d ${DOTFILES_CONFIG}/.ssh ]; then
        ln -vsf ${DOTFILES_CONFIG}/.ssh/config ${HOME}/.ssh/config
        ln -vsf ${DOTFILES_CONFIG}/.ssh/known_hosts ${HOME}/.ssh/known_hosts
    fi
    ##	Setup keyrings
    mkdir -p ${HOME}/.local/share
    test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
    ln -vsfn ${HOME}/backup/keyrings ${HOME}/.local/share/keyrings
}

##
## Run the main function
##

taskList

ppaTask

SSHTasks

packageTasks

devPackageTasks

extraTasks
