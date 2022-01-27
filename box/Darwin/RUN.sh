#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
         echo "Please run as root"
    exit 1
fi

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

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor

brew install make git wget openssl openssh

xcode-select --install

curl https://getmic.ro | bash

/dev/bus/usb/001/039

echo "options vfio-pci ids=8086:9d2f,10de:0fb9 disable_vga=1" > /etc/modprobe.d/vfio.conf##
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
