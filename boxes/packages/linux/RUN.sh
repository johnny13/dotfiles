#!/bin/bash

NOW=$(LC_ALL=C date +"%m-%d-%Y %r")                   # Returns: 06-14-2015 10:34:40 PM
DATESTAMP=$(LC_ALL=C date +%Y-%m-%d)                  # Returns: 2015-06-14
HOURSTAMP=$(LC_ALL=C date +%r)                        # Returns: 10:34:40 PM
TIMESTAMP=$(LC_ALL=C date +%Y%m%d_%H%M%S)             # Returns: 20150614_223440
LONGDATE=$(LC_ALL=C date +"%a, %d %b %Y %H:%M:%S %z") # Returns: Sun, 10 Jan 2016 20:47:53 -0500
GMTDATE=$(LC_ALL=C date -u -R | sed 's/\+0000/GMT/')  # Returns: Wed, 13 Jan 2016 15:55:29 GMT

LOGFILE='fresh-install-log'
LOGMSG=1

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

_setColors_()
{
    if tput setaf 1 &>/dev/null; then

        # COLOR OPTIONS
        NORMAL="$(tput sgr0)" # Text Reset
        NC="$(tput sgr0)" # Text Reset
        BOLD="$(tput bold)" # Make Bold
        UNDERLINE="$(tput smul)" # Underline
        NOUNDER="$(tput rmul)" # Remove Underline
        BLINK="$(tput blink)" # Make Blink
        REVERSE="$(tput rev)" # Reverse

        if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
            BLK="$(tput setaf 252)" # Black
            RED="$(tput setaf 44)" # Red
            GRN="$(tput setaf 164)" # Green
            YLW="$(tput setaf 21)" # Yellow
            BLU="$(tput setaf 172)" # Blue
            PUR="$(tput setaf 184)" # Purple
            CYN="$(tput setaf 172)" # Cyan
            WHT="$(tput setaf 232)" # White
        else
            BLK="$(tput setaf 0)" # Black
            RED="$(tput setaf 1)" # Red
            GRN="$(tput setaf 2)" # Green
            YLW="$(tput setaf 3)" # Yellow
            BLU="$(tput setaf 4)" # Blue
            PUR="$(tput setaf 5)" # Purple
            CYN="$(tput setaf 6)" # Cyan
            WHT="$(tput setaf 7)" # White
        fi

        # BOLD TEXT COLORS
        BBLK="$(tput setaf 8)" # Black
        BRED="$(tput setaf 9)" # Red
        BGRN="$(tput setaf 10)" # Green
        BYLW="$(tput setaf 11)" # Yellow
        BBLU="$(tput setaf 12)" # Blue
        BPUR="$(tput setaf 13)" # Purple
        BCYN="$(tput setaf 14)" # Cyan
        BWHT="$(tput setaf 15)" # White

        # REGULAR BACKGROUND COLORS
        B_BLK="$(tput setab 0)" # Black
        B_RED="$(tput setab 1)" # Red
        B_GRN="$(tput setab 2)" # Green
        B_YLW="$(tput setab 3)" # Yellow
        B_BLU="$(tput setab 4)" # Blue
        B_PUR="$(tput setab 5)" # Purple
        B_CYN="$(tput setab 6)" # Cyan
        B_WHT="$(tput setab 7)" # White

        # BOLD BACKGROUND COLORS
        BB_BLK="$(tput setab 8)" # Black
        BB_RED="$(tput setab 9)" # Red
        BB_GRN="$(tput setab 10)" # Green
        BB_YLW="$(tput setab 11)" # Yellow
        BB_BLU="$(tput setab 12)" # Blue
        BB_PUR="$(tput setab 13)" # Purple
        BB_CYN="$(tput setab 14)" # Cyan
        BB_WHT="$(tput setab 7)" # White
    else

        # REGULAR TEXT COLORS
        BLK="\e[1;30m" # Black
        RED="\e[1;31m" # Red
        GRN="\e[1;32m" # Green
        YLW="\e[1;33m" # Yellow
        BLU="\e[1;34m" # Blue
        PUR="\e[1;35m" # Purple
        CYN="\e[1;36m" # Cyan
        WHT="\e[1;37m" # White

        # BOLD TEXT COLORS
        BBLK="\e[1;30m" # Black
        BRED="\e[1;31m" # Red
        BGRN="\e[1;32m" # Green
        BYLW="\e[1;33m" # Yellow
        BBLU="\e[1;34m" # Blue
        BPUR="\e[1;35m" # Purple
        BCYN="\e[1;36m" # Cyan
        BWHT="\e[1;37m" # White

        # BACKGROUND COLORS
        B_BLK="\e[40m" # Black
        B_RED="\e[41m" # Red
        B_GRN="\e[42m" # Green
        B_YLW="\e[43m" # Yellow
        B_BLU="\e[44m" # Blue
        B_PUR="\e[45m" # Purple
        B_CYN="\e[46m" # Cyan
        B_WHT="\e[47m" # White

        # BOLD BACKGROUND
        BB_BLK="\e[1;40m" # Black
        BB_RED="\e[1;41m" # Red
        BB_GRN="\e[1;42m" # Green
        BB_YLW="\e[1;43m" # Yellow
        BB_BLU="\e[1;44m" # Blue
        BB_PUR="\e[1;45m" # Purple
        BB_CYN="\e[1;46m" # Cyan
        BB_WHT="\e[1;47m" # White

        # COLOR OPTIONS
        NORMAL="\e[0m" # Text Reset
        BOLD="\e[1m" # Make Bold
        UNDERLINE="\e[4m" # Underline
        NOUNDER="\e[24m" # Remove Underline
        BLINK="\e[5m" # Make Blink
        NOBLINK="\e[25m" # NO Blink
        REVERSE="\e[50m" # Reverse
    fi
}

_setMessages_()
{
    if tput setaf 1 &>/dev/null; then
        GOODSTRING="$(tput bold)$(tput setaf 7)$(tput setab 12)[ OK ]$(tput sgr0)"
        BADSTRING="$(tput bold)$(tput setaf 8)$(tput setab 9)[FAIL]$(tput sgr0)"
        INFOSTRING="$(tput bold)$(tput setaf 7)$(tput setab 14)[INFO]$(tput sgr0)"
        DONESTRING="$(tput bold)$(tput setaf 7)$(tput setab 10)[DONE]$(tput sgr0)"
        MAKESTRING="$(tput bold)$(tput setaf 7)$(tput setab 13)[MAKE]$(tput sgr0)"
        WARNSTRING="$(tput bold)$(tput setaf 8)$(tput setab 11)[WARN]$(tput sgr0)"
    else
        GOODSTRING="\e[1m\e[1;37m\e[1;44m[ OK ]\e[0m"
        BADSTRING="\e[1m\e[1;30m\e[1;41m[FAIL]\e[0m "
        INFOSTRING="\e[1m\e[1;30m\e[1;46m[INFO]\e[0m"
        DONESTRING="\e[1m\e[1;37m\e[1;42m[DONE]\e[0m"
        MAKESTRING="\e[1m\e[1;37m\e[1;45m[MAKE]\e[0m"
        WARNSTRING="\e[1m\e[1;30m\e[1;43m[WARN]\e[0m"
    fi
}

##
## MAIN OUTPUT_MSG PRINTING FUNCTION
## EX: PMSG "INFO" "Test Message Info"
##
PMSG()
{
    if [[ "$LOGMSG" -ne 0 ]]; then
        if [ -z "${LOGFILE:-}" ]; then
            LOGFILE="$(pwd)/$(basename "$0").log"
        fi
        [ ! -d "$(dirname "${LOGFILE}")" ] && mkdir -p "$(dirname "${LOGFILE}")"
        [[ ! -f ${LOGFILE} ]] && touch "${LOGFILE}"

        # Don't use colors in logs
        if command -v gsed &>/dev/null; then
            local cleanmessage="$(echo "${2}" | gsed -E 's/(\x1b)?\[(([0-9]{1,2})(;[0-9]{1,3}){0,2})?[mGK]//g')"
        else
            local cleanmessage="$(echo "${2}" | sed -E 's/(\x1b)?\[(([0-9]{1,2})(;[0-9]{1,3}){0,2})?[mGK]//g')"
        fi

        echo -e "$(date +"%b %d %R:%S") $(printf "[%4s]" "${1}") [$(/bin/hostname)] ${2}" >>"${LOGFILE}"
    fi

    STATS=$( date +'%I:%M.%S')
    STATSTRING="${BWHT}[${BLK}${STATS}${BWHT}]"

    case $1 in

        GOOD)
            printf "\n${GOODSTRING}${STATSTRING} ${BBLU}%s${NC}" "$2"
            ;;

        BAD)
            printf "\n${BADSTRING}${STATSTRING} ${BRED}%s${NC}" "$2"
            _safeExit_ "1"
            ;;

        INFO)
            printf "\n${INFOSTRING}${STATSTRING} ${BCYN}%s${NC}" "$2"
            ;;

        WARN)
            printf "\n${WARNSTRING}${STATSTRING} ${BYLW}%s${NC}" "$2"
            ;;

        DONE)
            printf "\n${DONESTRING}${STATSTRING} ${BGRN}%s${NC}" "$2"
            ;;

        MAKE)
            printf "\n${MAKESTRING}${STATSTRING} ${BPUR}%s${NC}" "$2"
            ;;

        *)
            printf "\n${INFOSTRING}${STATSTRING} ${BWHT}%s${NC}" "$2"
            ;;

    esac
}

## Print a horizontal rule
## @param $1 default line break char. ie: -
ruleln()
{
    if [ "$#" -lt 2 ]; then
        COLS=$(tput cols)
    else
        COLS="$2"
    fi

    printf -v _hr "%*s" "${COLS}" && echo "${_hr// /${1--}}"
}

## Print horizontal ruler with message
## @param $1 message we are going to display
## @param $2 default line break char. ie: -
rulemsg()
{
    if [ "$#" -eq 0 ]; then
        echo "Usage: rulemsg MESSAGE [RULE_CHARACTER]"
        return 1
    fi

    # Store Cursor.
    # Fill line with ruler character ($2, default "-")
    # Reset cursor
    # move 10 cols right, print message

    tput sc # save cursor
    printf -v _hr "%*s" 80 && echo -n "${BWHT}" && echo -en ${_hr// /${2--}} && echo -en "\r\033[2C"
    tput rc

    echo -en "\r\033[10C" && echo -n " ${BB_GRN}${BBLK}| $1 |${NC}" # 10 space in

    echo " " # now we break

    pause

    echo " "
}

logFileLineBreak()
{
    STATS=$( date +'%I:%M.%S')
    echo -e "\n\n" >>${LOGFILE}
    echo -e "•• ━━━━━━━━ • ━━━ • [ ${STATS} ] ━━━ • ━━ •" >>${LOGFILE}
    echo -e "\n" >>${LOGFILE}
}

finishEcho()
{
    echo -e "\n\t${BGRN}◼◼◼◼◼◼◼▶ $1 FINISHED!\n${NORMAL}\n\n"
}

pause()
{
    echo ""
    local message="$@"
    [ -z "$message" ] && message="       Press [Enter] key to continue:  "
    read -rp "$message" readEnterKey
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

# SCRIPT SETUP
## ------------------ ---------  ------   ----    ---     --      -
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

# Exit on error. Append '||true' if you expect an error
set -o errexit

# Trap errors in subshells and functions
set -e
set -o pipefail

traperr()
{
    PMSG "FAIL" "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

# Set IFS to preferred implementation
IFS=$' \n\t'

_setColors_
_setMessages_

# Disallow expansion of unset variables
set -o nounset

banner

sleep 2

# 	Display 5 seconds count down before script executes
for i in $(seq 5 -1 1); do
    echo -ne "${BBLU}$i\r${BGRN}Getting ready to proceed with the automation in... ${NC}"
    sleep 1
done

# PMSG "INFO" "Testing 123"

# PMSG "MAKE" "Testing 123456"

# echo -e "\n\n"
# rulemsg "New Heading" "◼"
# echo -e "\n\n"
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
#/usr/bin/env bash

echo "Albert Install Script"

echo ""
echo "Repo Setup"
echo ""

curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
sudo wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_20.04/Release.key -O "/etc/apt/trusted.gpg.d/home:manuelschneid3r.asc"

echo ""
echo "Updating!"
echo ""

sudo apt update -y

echo ""
echo "Installing!"
echo ""

sudo apt install -y albert

echo ""
echo "Finished!"
echo ""
##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
rulemsg "RC Dotfiles"
PMSG "INFO" "CLONING DOTFILES REPO"
#mkdir -p "${rcDir}"
if [ -d "${rcDir}" ]; then
    rm -r $rcDir
fi

git clone "https://github.com/johnny13/dotfiles" $rcDir

#echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
#source  ~/.bashrc

ruleln "-" 60

##
## RUST SETUP
##

rulemsg "Rust Setup"
PMSG "INFO" "RUST + CARGO CRATES"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

rustup component add clippy

cargo install eureka
cargo install exa
cargo install pastel

ruleln "-" 60

finishEcho "BOX SETUP"
