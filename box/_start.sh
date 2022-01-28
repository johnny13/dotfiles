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
