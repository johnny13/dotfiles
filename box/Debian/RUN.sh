#!/usr/bin/env bash

# if [ "$EUID" -ne 0 ]; then
#          echo "Please run as root"
#     exit 1
# fi

set -e
set -o pipefail

traperr()
          {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

LOGFILE='fresh-install-log'
#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------
#
#  ██████╗ ██████╗ ██╗███╗   ███╗███╗   ███╗███████╗████████╗ █████╗ ██████╗
# ██╔════╝ ██╔══██╗██║████╗ ████║████╗ ████║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗
# ██║  ███╗██████╔╝██║██╔████╔██║██╔████╔██║███████╗   ██║   ███████║██████╔╝
# ██║   ██║██╔══██╗██║██║╚██╔╝██║██║╚██╔╝██║╚════██║   ██║   ██╔══██║██╔══██╗
# ╚██████╔╝██║  ██║██║██║ ╚═╝ ██║██║ ╚═╝ ██║███████║   ██║   ██║  ██║██║  ██║
#  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
#
#---------------------------------------------------------------------------------------------
#
#   Color Codes
#       A list that can be sourced and used for scripting purposes.
#
#   Source:
#       [Cyriina's .dotfiles](https://github.com/Grimmstar/.dotfiles)
#
#   Authors:
#       Cyriina Grimm <xxgrimmchildxx@gmail.com>
#
#---------------------------------------------------------------------------------------------

# Reset
NC='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'             # Black
White='\033[0;37m'             # White
Red='\033[0;31m'               # Red
Orange='\033[0;38;5;214m'      # Orange
Yellow='\033[0;38;5;227m'      # Yellow
Green='\033[0;32m'             # Green
Cyan='\033[0;38;5;51m'         # Cyan
Blue='\033[0;38;5;33m'         # Blue
Purple='\033[0;38;5;105m'      # Purple
LightPurple='\033[0;38;5;177m' # Light Purple
Pink='\033[0;38;5;200m'        # Pink
Grey='\033[0;38;5;246m'        # Grey

# Bold
BBlack='\033[1;30m'             # Black
BWhite='\033[1;37m'             # White
BRed='\033[1;31m'               # Red
BOrange='\033[1;38;5;214m'      # Orange
BYellow='\033[1;38;5;227m'      # Yellow
BGreen='\033[1;32m'             # Green
BCyan='\033[1;38;5;51m'         # Cyan
BBlue='\033[1;38;5;33m'         # Blue
BPurple='\033[1;38;5;105m'      # Purple
BLightPurple='\033[1;38;5;177m' # Light Purple
BPink='\033[1;38;5;200m'        # Pink
BGrey='\033[1;38;5;246m'        # Grey

# Underline
UBlack='\033[4;30m'             # Black
UWhite='\033[4;37m'             # White
URed='\033[4;31m'               # Red
UOrange='\033[4;38;5;214m'      # Orange
UYellow='\033[4;38;5;227m'      # Yellow
UGreen='\033[4;32m'             # Green
UCyan='\033[4;38;5;51m'         # Cyan
UBlue='\033[4;38;5;33m'         # Blue
UPurple='\033[4;38;5;105m'      # Purple
ULightPurple='\033[4;38;5;177m' # Light Purple
UPink='\033[4;38;5;200m'        # Pink
UGrey='\033[4;38;5;246m'        # Grey

# Background
On_Black='\033[40m'        # Black
On_White='\033[47m'        # White
On_Red='\033[41m'          # Red
On_Orange='\033[214m'      # Orange
On_Yellow='\033[43m'       # Yellow
On_Green='\033[42m'        # Green
On_Cyan='\033[46m'         # Cyan
On_Blue='\033[44m'         # Blue
On_Purple='\033[45m'       # Purple
On_LightPurple='\033[177m' # Light Purple
On_Pink='\033[200m'        # Pink
On_Grey='\033[246m'        # Grey

# High Intensity
IBlack='\033[0;90m'        # Black
IWhite='\033[0;97m'        # White
IRed='\033[0;91m'          # Red
IOrange='\033[0;214m'      # Orange
IYellow='\033[0;93m'       # Yellow
IGreen='\033[0;92m'        # Green
ICyan='\033[0;96m'         # Cyan
IBlue='\033[0;94m'         # Blue
IPurple='\033[0;95m'       # Purple
ILightPurple='\033[0;177m' # Light Purple
IPink='\033[0;200m'        # Pink
IGrey='\033[0;246m'        # Grey

# Bold High Intensity
BIBlack='\033[1;90m'        # Black
BIWhite='\033[1;97m'        # White
BIRed='\033[1;91m'          # Red
BIOrange='\033[1;214m'      # Orange
BIYellow='\033[1;93m'       # Yellow
BIGreen='\033[1;92m'        # Green
BICyan='\033[1;96m'         # Cyan
BIBlue='\033[1;94m'         # Blue
BIPurple='\033[1;95m'       # Purple
BILightPurple='\033[1;177m' # Light Purple
BIPink='\033[1;200m'        # Pink
BIGrey='\033[1;246m'        # Grey

# High Intensity backgrounds
On_IBlack='\033[0;100m'       # Black
On_IWhite='\033[0;107m'       # White
On_IRed='\033[0;101m'         # Red
On_IOrange='\033[0;214m'      # Orange
On_IYellow='\033[0;103m'      # Yellow
On_IGreen='\033[0;102m'       # Green
On_ICyan='\033[0;106m'        # Cyan
On_IBlue='\033[0;104m'        # Blue
On_IPurple='\033[0;105m'      # Purple
On_ILightPurple='\033[0;177m' # Light Purple
On_IPink='\033[0;200m'        # Pink
On_IGrey='\033[0;246m'        # Grey

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
NC="\e[0m"  # Text Reset

if tput setaf 1 &>/dev/null; then
    GOODSTRING="$(tput bold)$(tput setaf 7)$(tput setab 2)[ 😎 ]$(tput sgr0)"
    BADSTRING="$(tput bold)$(tput setaf 8)$(tput setab 9)[FAIL]$(tput sgr0)"
    INFOSTRING="$(tput bold)$(tput setaf 15)$(tput setab 12)[ 💡 ]$(tput sgr0)"
    MERGSTRING="$(tput bold)$(tput setaf 15)$(tput setab 14)[ 🔃 ]$(tput sgr0)"
    MAKESTRING="$(tput bold)$(tput setaf 15)$(tput setab 13)[ 📦 ]$(tput sgr0)"
    WARNSTRING="$(tput bold)$(tput setaf 8)$(tput setab 11)[WARN]$(tput sgr0)"
else
    GOODSTRING="\e[1m\e[1;37m\e[1;42m[ OK ]\e[0m"
    BADSTRING="\e[1m\e[1;30m\e[1;41m[FAIL]\e[0m "
    INFOSTRING="\e[1m\e[1;37m\e[1;44m[INFO]\e[0m"
    MERGSTRING="\e[1m\e[1;37m\e[1;46m[MERG]\e[0m"
    MAKESTRING="\e[1m\e[1;37m\e[1;45m[MAKE]\e[0m"
    WARNSTRING="\e[1m\e[1;30m\e[1;43m[WARN]\e[0m"
fi

OUTPUT_MSG()
{
    case $1 in

        GOOD)
            echo -e "${GOODSTRING} ${2}"
            ;;

        BAD)
            echo -e "\n${BADSTRING} ${2}\n"
            ;;

        INFO)
            echo -e "${INFOSTRING} ${2}"
            ;;

        WARN)
            echo -e "${WARNSTRING} ${2}"
            ;;

        MERG)
            echo -e "${MERGSTRING} ${2}"
            ;;

        MAKE)
            echo -e "${MAKESTRING} ${2}"
            ;;

        *)
            echo -e "${INFOSTRING} ${2}"
            ;;

    esac

    echo -n "$NORMAL"
}

c_info()
         {
    printf "\n ⭐${BGrey} %s${NC}\n" "$@"
    sleep 1
}

c_question()
             {
    printf "\n ❔${BCyan} %s${NC}\n" "$@"
    sleep 1
}

c_success()
            {
    printf "\n ✔️ ${BGreen} %s${NC}\n" "$@"
    sleep 1
}

c_error()
          {
    printf "\n ❌ ${Red} %s${NC}\n" "$@"
    sleep 1
}

c_warning()
            {
    printf "\n ⚠️ ${BYellow} %s${NC}\n" "$@"
    sleep 1
}

c_install()
            {
    printf "\n 🚧 ${Grey} %s${NC}\n" "$@"
}

c_hilight()
            {
    printf "${LightPurple} %s${NC}" "$@"
}
# File Checks
## ------------------ ---------  ------   ----    ---     --      -
#   A series of functions which make checks against the filesystem.
#   For use in if/then statements.
#
#   Usage:
#      if is_file "file"; then
#         ...
#      fi
## ------------------ ---------  ------   ----    ---     --      -
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

# Returns whether the given command is executable or aliased.
_has()
{
    return $(which $1 >/dev/null)
}

is_exists()
{
    if [[ -e "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_exists()
{
    if [[ ! -e "$1" ]]; then
        return 0
    fi
    return 1
}

is_file()
{
    if [[ -f "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_file()
{
    if [[ ! -f "$1" ]]; then
        return 0
    fi
    return 1
}

is_dir()
{
    if [[ -d "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_dir()
{
    if [[ ! -d "$1" ]]; then
        return 0
    fi
    return 1
}

is_symlink()
{
    if [[ -L "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_symlink()
{
    if [[ ! -L "$1" ]]; then
        return 0
    fi
    return 1
}

is_empty()
{
    if [[ -z "$1" ]]; then
        return 0
    fi
    return 1
}

is_not_empty()
{
    if [[ -n "$1" ]]; then
        return 0
    fi
    return 1
}
###
### UI FUNCTIONS
###

banner()
{
    echo -e "${BPUR}"

    cat <<EOF


                          0000000..   .,-00000
                          ||||^^||||,|||*^^^^*
                          [[[,/[[[* [[[
                          XXXXXxx   XXX
                          888b ^88bo*88bo.__.o
EOF

    echo -en "${BCYN}"

    cat <<EOF
  .--.      .--.      .--. .+----------------+.   .--.      .--.      .--.
:::::.\::::::::.\::::::::.| RESEARCH CHEMICALS |:::::.\::::::::.\::::::::.\::
       '--'      '--'      '+----------------+'        '--'      '--'      '

EOF
    echo -e "${NORMAL}"

}

taskName()
{
    STATS=$( date +'%I:%M.%S')
    printf "
${BPurple}◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼
${NC}\t 🎃 ${BGRN}${STATS} ${BCYN}❱❱  ${BWhite} $1
${BPurple}◼ ◼ ◼ ◼ ◼  ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼${NC}"
}

taskStatus()
{
    echo -e "\n\t${BCYN}•••━ • ━•${BBLU}❪ ${BWHT}$1 ${BBLU}❫${BCYN}━━ • ━━${BPUR}[ ${BWHT}$2 ${BPUR}] ❱${NORMAL}\n"
}

lineBreak()
{
    echo -e "\n\t${BYLW}•••••\t${BGRN}•••••\t${BBLU}•••••\t${BPUR}•••••\t${BRED}•••••\n${NORMAL}"
}

finishEcho()
{
    echo -e "\n\t${BGRN}━━━━━━▶ $1 FINISHED!\n${NORMAL}\n\n"
}

logFileLineBreak()
{
    STATS=$( date +'%I:%M.%S')
    echo -e "\n\n" >> ${LOGFILE}
    echo -e "•• ━━━━━━━━ • ━━━ • [ ${STATS} ] ━━━ • ━━ •" >> ${LOGFILE}
    echo -e "\n" >> ${LOGFILE}
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

sleep 2

# 	Display 5 seconds count down before script executes
for i in $(seq 5 -1 1); do
    echo -ne "$i\rGetting ready to proceed with the automation in... "
    sleep 1
done
#!/usr/bin/env bash

taskList()
{
    taskName "BOOTSTRAP START"
    taskStatus "SETUP" "SYSTEM UPDATE & UPGRADE"
    miniLibs
    lineBreak

    taskName "SETUP"
    taskStatus "HOME" "CREATE DIRECTORY"
    cd ~
    mkdir -p ./Developer
    cd ./Developer
    lineBreak
}

packageTasks()
{
    taskName "INSTALL"
    taskStatus "APT" "PACKAGE INSTALLER"
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
    lineBreak
}

SSHTasks()
{
    taskName "INSTALL"
    taskStatus "SSH" "SECURE SETUP"
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
    lineBreak
}

EXTRATasks()
{
    taskName "INSTALL"
    taskStatus "CODE" "PHP APACHE NODE.JS"
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
    lineBreak
}

devPackageTasks()
{
    taskName "INSTALL"
    taskStatus "APT" "DEV PACKAGE INSTALLER"
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
    lineBreak
}

extraTasks()
{
    taskName "GITHUB"
    taskStatus "ADD" "GH CLI TOOL"
    addGHSources
    lineBreak

    taskName "APACHE2"
    taskStatus "HTTP" "APACHE WEBSERVER INSTALL"
    addApache
    lineBreak

    taskName "PHP-7 DEBIAN"
    taskStatus "GIT" "FETCHING REPO"
    git clone https://github.com/kasparsd/php-7-debian.git php7
    cd php7
    ./build.sh
    sudo ./install.sh
    sudo ln -s /usr/local/php7/bin/php /usr/local/bin/php
    lineBreak

    taskName "Node.js"
    taskStatus "NVM" "NODE VERSION MANAGER"
    addNode
    lineBreak

    finishEcho "DEBIAN FUNCTIONS"
}

ppaTask()
{
    taskName "ADD SOURCES"
    sleep 1
    taskStatus "APT" "ADD PPA REPOS FOR GIT, DOCKER, NGINX ETC"
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

    lineBreak
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

    sudo apt update
    sudo apt install -y gh
}

# Quickly install minimum amount of packages to make things work
miniLibs()
{
    sudo apt-get update && sudo apt-get upgrade -y >>${LOGFILE}
    sudo apt-get dist-upgrade -f >>${LOGFILE}
    sudo apt autoremove -y >>${LOGFILE}

    sudo apt install -y git ufw wget curl sudo gcc build-essential software-properties-common unzip >>${LOGFILE}
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
                sudo apt-get install -y ${i} >>${LOGFILE}
            else
                c_success "Package ${i} is already installed. Skipping..."
            fi
        done
    else
        c_error "No Packages file found. Skipping package installation..."
    fi

    # sudo apt install -y xutils-dev dialog nano micro sassc  checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev openssl libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev >>${LOGFILE}

    # sudo apt install -y lsb-release apt-transport-https ca-certificates openssl openssh-server openssh-client openjdk-14-jdk openjdk-14-jre parted pastebinit qemu-kvm rsync shc ssh-import-id ssh-askpass-gnome ssl-cert synaptic spacefm unrar vagrant xdotool xclip zip yadm android-file-transfer android-sdk-platform-tools-common ansiweather caca-utils cmake automake debconf dconf-cli dkms fo nt-manager font-viewer fontconfig ftp fuse gawk gettext ghostscript gparted gpart gpg htop iftop imagemagick jo >>${LOGFILE}

    # sudo apt install -y tcl-tls python-openssl mcrypt python3-m2crypto gnupg2 dirmngr git-core libreadline-dev libyaml-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev >>${LOGFILE}

    # python3 ruby sassc apache2 mysql-server php-cli php-mbstring xterm

    sudo apt update && sudo apt upgrade -y >>${LOGFILE}
    sudo apt autoremove -y >>${LOGFILE}
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
                sudo apt-get install -y ${i} >>${LOGFILE}
            else
                c_success "DEV Package ${i} is already installed. Skipping..."
            fi
        done
    else
        c_error "No DEV Packages file found. Skipping DEV package installation..."
    fi

    sudo apt update && sudo apt upgrade -y >>${LOGFILE}
    sudo apt autoremove -y >>${LOGFILE}
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
    sudo apt-get update && sudo apt-get upgrade -y >>${LOGFILE}
    sudo apt-get dist-upgrade -f >>${LOGFILE}
    sudo apt autoremove -y >>${LOGFILE}
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
##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
taskName "Dotfiles"
taskStatus "SETUP" "CLONING DOTFILES REPO"
#mkdir -p "${rcDir}"
if [ -d "${rcDir}" ]; then
    rm -r $rcDir
fi

git clone "https://github.com/johnny13/dotfiles" $rcDir

#echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
#source  ~/.bashrc

lineBreak

##
## RUST SETUP
##

taskName "Rust"
taskStatus "INSTALL" "RUST + CARGO CRATES"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

rustup component add clippy

cargo install eureka
cargo install exa
cargo install pastel
lineBreak

finishEcho "BOX SETUP"
