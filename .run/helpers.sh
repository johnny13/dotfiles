apt_or_brew_helperInstaller()
{

    PACKAGE_NAME="$1"

    APT_GET_CMD=$(command -v apt-get)
    BREW_CMD=$(command -v brew)

    if [[ ! -z $APT_GET_CMD ]]; then
        apt install -y "${PACKAGE_NAME}"
    elif [[ ! -z $BREW_CMD ]]; then
        brew install "${PACKAGE_NAME}"
    else
        echo "error can't install package ${PACKAGE_NAME}"
        exit 1
    fi
}

getOSType()
{
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "MacOS"
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "Windows"
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "Windows"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "Nix of some kind"
    else
        echo "UNKNOWN!"
    fi
}

# Pause prompt.
# Suspend processing of script; display message prompting user to press [Enter] key to continue.
# $1-> Message (optional)

pause()
{
    echo ""
    local message="$@"
    [ -z "$message" ] && message="       Press [Enter] key to continue:  "
    read -rp "$message" readEnterKey
}

# COLOR OPTIONS
BRED="\e[1;31m" # Red
BBLU="\e[1;34m" # Blue
BGRN="\e[1;32m" # Green
BCYN="\e[1;36m" # Cyan
BWHT="\e[1;37m" # White
BPUR="\e[1;35m" # Purple
BYLW="\e[1;33m" # Yellow
NORMAL="\e[0m"  # Text Reset

## OUTPUT MESSAGE LOGGING
## -------------------------
if tput setaf 1 &>/dev/null; then
    GOODSTRING="$(tput bold)$(tput setaf 7)$(tput setab 2)[GOOD]$(tput sgr0)"
    BADSTRING="$(tput bold)$(tput setaf 8)$(tput setab 9)[FAIL]$(tput sgr0)"
    INFOSTRING="$(tput bold)$(tput setaf 15)$(tput setab 12)[INFO]$(tput sgr0)"
    MERGSTRING="$(tput bold)$(tput setaf 15)$(tput setab 14)[MERG]$(tput sgr0)"
    MAKESTRING="$(tput bold)$(tput setaf 15)$(tput setab 13)[MAKE]$(tput sgr0)"
    WARNSTRING="$(tput bold)$(tput setaf 8)$(tput setab 11)[WARN]$(tput sgr0)"
    NORMAL="$(tput sgr0)"
else
    GOODSTRING="\e[1m\e[1;37m\e[1;42m[ OK ]\e[0m"
    BADSTRING="\e[1m\e[1;30m\e[1;41m[FAIL]\e[0m "
    MERGSTRING="\e[1m\e[1;37m\e[1;46m[MERG]\e[0m"
    MAKESTRING="\e[1m\e[1;37m\e[1;45m[MAKE]\e[0m"
    INFOSTRING="\e[1m\e[1;37m\e[1;44m[INFO]\e[0m"
    WARNSTRING="\e[1m\e[1;30m\e[1;43m[WARN]\e[0m"
    NORMAL="\e[0m"
fi

OUTPUT_MSG()
{

    case $1 in

        GOOD)
            echoMenuRow "${GOODSTRING} ${2}" 8
            ;;

        BAD)
            echoMenuRow "\n${BADSTRING} ${2}\n" 8
            ;;

        INFO)
            echoMenuRow "${INFOSTRING} ${2}" 8
            ;;

        WARN)
            echoMenuRow "${WARNSTRING} ${2}" 8
            ;;

        MERG)
            echoMenuRow "${MERGSTRING} ${2}" 8
            ;;

        MAKE)
            echoMenuRow "${MAKESTRING} ${2}" 8
            ;;

        *)
            echoMenuRow "${INFOSTRING} ${2}" 8
            ;;

    esac

    echo -n "$NORMAL"
}

## ASCII OUTPUT
## ------------------------
_hashes()
{
    ansi::forward 12
    ansi::color 11
    printf -v _hr "%*s" "${2}" && echo -e "${_hr// /${1--}}"
    ansi::resetForeground
}

## Print ASCII Header Message
run_banner()
{
    echo -e "\n"
    #ansi::forward 12
    _hashes "$2" "$3"
    ansi::color 45
    ansi::forward 12
    echo -e "$1"
    _hashes "$2" "$3"
    ansi::resetForeground
}

## Repeat given char N times using shell function
## EX: repeat 80 '-'; echo
repeat()
{
    local start=1
    local end=${1:-80}
    local str="${2:-=}"
    local range=$(seq $start $end)
    for i in $range; do echo -n "${str}"; done
}

# Source a file if it exists
source_if_exists()
{
    if [ -f "$1" ]; then
        . "$1"
    fi
}

dir_check()
{
    MESSAGE="$2"
    if [ -z "$MESSAGE" ]; then
        MESSAGE="Directory: $1 does not exist or you have not the right permissions to read!"
    fi
    if [ ! -d "$1" ]; then
        echo "$MESSAGE"
        exit 1
    fi
}
