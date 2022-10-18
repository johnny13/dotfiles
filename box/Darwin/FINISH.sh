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
has_command()
{
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

test_command()
{
  if has_command $1; then
    e_success "$1"
  else
    e_failure "$1"
  fi
}

has_brew()
{
  if $(brew ls --versions $1 >/dev/null); then
    return 0
  fi
  return 1
}

test_brew()
 {
  if has_brew $1; then
    e_success "$1"
  else
    e_failure "$1"
  fi
}

has_path()
{
  local path="$@"
  if [ -e "$HOME/$path" ]; then
    return 0
  fi
  return 1
}

test_path()
{
  # local path=$(echo "$@" | sed 's:.*/::')
  if has_path $1; then
    # e_success "$path"
    e_success "$1"
  else
    # e_failure "$path"
    e_failure "$1"
  fi
}

has_cask()
{
  if $(brew ls --cask $1 &>/dev/null); then
    return 0
  fi
  return 1
}

test_cask()
{
  if has_cask $1; then
    e_success "$1"
  else
    e_failure "$1"
  fi
}

has_app()
{
  local name="$@"
  if [ -e "/Applications/$name.app" ]; then
    return 0
  fi
  return 1
}

test_app()
{
  if has_app $1; then
    e_success "$1"
  else
    e_failure "$1"
  fi
}

has_arm()
{
  if [[ $(uname -p) == 'arm' ]]; then
    return 0
  fi
  return 1
}

has_consent()
{
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

get_consent()
{
  printf "❔  %s? [y/n]:" "$@"
  read -p " " -n 1
  printf "\n"
}

install()
{
    cmd=$1
    shift
    for pkg in "$@"; do
        exec="$cmd $pkg"
        if ${exec}; then
            PMSG "INFO" "Installed $pkg"
    else
            PMSG "WARN" "Failed to execute: $exec"
            if [[ ! -z "${CI}" ]]; then
                exit 1
      fi
    fi
  done
}

if ! [[ "${OSTYPE}" == "darwin"* ]]; then
  e_failure "Unsupported operating system (macOS only)"
  exit 1
fi
JDK_VERSION="amazon-corretto@1.8.222-10.1"

declare -a fonts=(
    font-fira-code
    font-source-code-pro
)

git_email='derek@huement.com'
declare -a git_configs=(
    "branch.autoSetupRebase always"
    "color.ui auto"
    "core.autocrlf input"
    "credential.helper osxkeychain"
    "merge.ff false"
    "pull.rebase true"
    "push.default simple"
    "rebase.autostash true"
    "rerere.autoUpdate true"
    "remote.origin.prune true"
    "rerere.enabled true"
    "user.name derekscott"
    "user.email ${git_email}"
)

declare -a pips=(
    pip
    glances
    ohmu
    pythonpy
)

declare -a gems=(
    bundler
)

# ------------------------------------------------------------------------------
rulemsg "Additional Dev Items"
# ------------------------------------------------------------------------------

PMSG "INFO" "Install JDK=${JDK_VERSION}"
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
jabba install ${JDK_VERSION}
jabba alias default ${JDK_VERSION}
java -version

##
## TODO FIX CASKROOM FONTS!
# PMSG "INFO" "Fonts Installer"
# brew tap caskroom/fonts
# install 'brew cask install' "${fonts[@]}"

PMSG "INFO" "Set git defaults"
for config in "${git_configs[@]}"; do
    git config --global ${config}
done

PMSG "INFO" "BASH Additionals"
brew install bash bash-completion@2 fzf wget
brew install --appdir="~/Applications" xquartz --cask

PMSG "INFO" "Install Python packages"
brew install python
brew install python3
install 'pip3 install --upgrade' "${pips[@]}"
pip3 install --upgrade pip setuptools wheel

##
## TODO FIX RUBY INSTALL. NEEDS ROOT!
# PMSG "INFO" "Install Ruby + Gems packages"
# brew install ruby-build
# brew install rbenv
# LINE='eval "$(rbenv init -)"'
# grep -q "$LINE" ~/.extra || echo "$LINE" >>~/.extra
# install 'gem install' "${gems[@]}"

PMSG "INFO" "Android Setup"
#brew cask install --appdir="~/Applications" java
#brew cask install --appdir="~/Applications" intellij-idea-ce
brew install --appdir="~/Applications" android-studio --cask
brew install android-sdk

PMSG "INFO" "QuickLook Plugins"
brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzip qlimagesize webpquicklook suspicious-package quicklookase qlvideo --cask

PMSG "INFO" "Install font tools."
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

PMSG "INFO" "Install some CTF tools; see https://github.com/ctfs/write-ups."
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
#brew install homebrew/x11/xpdf
brew install xz

PMSG "INFO" "Install other useful binaries."
brew install ack
brew install dark-mode
#brew install exiv2
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
brew install hub
brew install imagemagick
brew install lua
brew install lynx
brew install micro
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rhino
brew install speedtest_cli
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install zopfli
brew install pkg-config libffi
brew install pandoc
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Remove outdated versions from the cellar.
brew cleanup

echo ""

ruleln "-" 60

echo ""
echo ""

finishEcho "MacOS Section Complete"

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
