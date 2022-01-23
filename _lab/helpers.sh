keyboardHelp()
{
    ansi::color 45

    echo -e "\n\n"

    cat <<EOF
    Ctrl + A  Go to the beginning of the line you are currently typing on
    Ctrl + E  Go to the end of the line you are currently typing on
    Ctrl + L  Clears the Screen, similar to the clear command
    Ctrl + U  Clears the line before the cursor position. If you are at the end of the line, clears the entire line.
    Ctrl + H  Same as backspace
    Ctrl + R  Let’s you search through previously used commands
    Ctrl + C  Kill whatever you are running
    Ctrl + D  Exit the current shell
    Ctrl + Z  Puts whatever you are running into a suspended background process. fg restores it.
    Ctrl + W  Delete the word before the cursor
    Ctrl + K  Clear the line after the cursor
    Ctrl + T  Swap the last two characters before the cursor
    Esc + T  Swap the last two words before the cursor
    Alt + F  Move cursor forward one word on the current line
    Alt + B  Move cursor backward one word on the current line
    Tab Auto-complete files and folder names
EOF

    ansi::resetForeground
    echo -e "\n\n"

}

apt_or_brew_helperInstaller()
{

    PACKAGE_NAME="$1"

    APT_GET_CMD=$(command -v apt-get)
    BREW_CMD=$(command -v brew)

    if [[ ! -z $APT_GET_CMD ]]; then
        apt-get install -y "${PACKAGE_NAME}"
    elif [[ ! -z $OTHER_CMD ]]; then
        $BREW_CMD install "${PACKAGE_NAME}"
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
