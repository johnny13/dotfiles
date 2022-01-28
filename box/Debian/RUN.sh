#!/usr/bin/env bash

# if [ "$EUID" -ne 0 ]; then
#          echo "Please run as root"
#     exit 1
# fi

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

##
## COLOR OPTIONS
##

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


                0000000..    .,-00000
                ||||^^|||| ,|||*^^^^*
                [[[,/[[[*  [[[
                XXXXXxx    XXX
                888b ^88bo_*88bo.__.o
EOF

    echo -en "${BCYN}"

    cat <<EOF
  .--.      .--.      .--.      .--.      .--.
:::::.\::::::::.\::::::::.\::::::::.\::::::::.\::[ 0.13.1 ]
       '--'      '--'      '--'      '--'      '

EOF
    echo -e "${NORMAL}"

}

taskName()
{
    STATS=$( date +'%I:%M.%S')
    echo -e "\t${BPUR}◼◼◼ ◼◼ ◼${BCYN} $1 ${BWHT} ❱❱ ${BGRN}${STATS} ${NORMAL}"
}

taskStatus()
{
    echo -e "\t${BCYN}━━━${BBLU}❪ ${BWHT}$1 ${BBLU}❫${BCYN}━━━━━${BPUR}[ ${BWHT}$2 ${BPUR}]${NORMAL}"
}

lineBreak()
{
    echo -e "\n\t${BYLW}•••••\t${BGRN}•••••\t${BBLU}•••••\t${BPUR}•••••\t${BRED}•••••\n${NORMAL}"
}

finishEcho()
{
    echo -e "\n\t${BGRN}━━━━━━▶ $1 FINISHED!\n${NORMAL}\n\n"
}

# Checks if a command is installed
_hasCMD()
{
    if ! command -v $1 &>/dev/null; then
        #echo "${1} could not be found"
        return 1
    else
        return 0
        #echo "${1} was found"
    fi
}

###
### RUN SCRIPT
###

banner
#!/usr/bin/env bash

taskList()
{
    taskName "BOOTSTRAP START"
    taskStatus "SETUP" "SYSTEM UPDATE & UPGRADE"
    sudo apt update
    sudo apt upgrade
    lineBreak

    taskName "SETUP"
    taskStatus "HOME" "CREATE DIRECTORY"
    cd ~
    mkdir -p ./Developer
    cd ./Developer

    lineBreak

    taskName "INSTALL"
    taskStatus "APT" "PACKAGE INSTALLS"
    libraries
    lineBreak

    taskName "SOURCES"
    taskStatus "ADD" "GITHUB CLI TOOL"
    addSources
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
    sudo apt update && sudo apt install -y yarn

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
    sudo apt install -y gh
}

libraries()
{
    sudo apt install -y gcc git wget curl software-properties-common xutils-dev dialog nano micro sassc build-essential checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev openssl libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

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
##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
taskName "Dotfiles"
taskStatus "SETUP" "CLONING DOTFILES REPO"
mkdir -p "${rcDir}"
git clone "https://github.com/johnny13/dotfiles"

echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
source  ~/.bashrc

lineBreak

##
## RUST SETUP
##

taskName "Rust"
taskStatus "INSTALL" "RUST + CARGO CRATES"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

cargo install eureka
cargo install exa
cargo install pastel
lineBreak

finishEcho "BOX SETUP"
