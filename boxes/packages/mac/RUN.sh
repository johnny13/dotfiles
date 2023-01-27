#!/usr/bin/env bash

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
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Step 1: Update the OS and Install Xcode Tools
ruleln "-" 60
rulemsg "MacOS Updates & XCode Command Line Tools"

PMSG "INFO" "If this requires a restart, run the script again."

# Install all available updates
sudo softwareupdate -ia --verbose
# Install only recommended available updates
#sudo softwareupdate -ir --verbose

ruleln "-" 60
PMSG "INFO" "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

pause

for i in $(seq 5 -1 1); do
    echo -ne "${BBLU}$i\r${BGRN}Continue on to Settings + Apps automation in... ${NC}"
    sleep 1
done
echo ""
echo ""
echo "      ${BCYN}========================${NC}"
echo "         ${BPUR}Research Chemicals"
echo "      ${BGRN}Laboratory Synchronizing"
echo "      ${BCYN}========================${NC}"
echo ""
echo ""

declare -a app_name=(
    "authy"
    "lastpass"
    "aerial"
    "barrier"
    "brave-browser"
    "cakebrew"
    "diffmerge"
    "discord"
    "docker"
    "figma"
    "firefox"
    "github"
    "google-chrome"
    "google-drive"
    "hyper"
    "insomnia"
    "iterm2"
    "launchcontrol"
    "rectangle"
    "sidekick"
    "slack"
    "sourcetree"
    "spotify"
    "stats"
    "transmission"
    "typora"
    "visual-studio-code"
    "warp"
    "zoom"
)

declare -a app_desc=(
    "Authy Desktop"
    "LastPass"
    "Aerial Screensaver"
    "Barrier"
    "Brave Browser"
    "Cakebrew"
    "DiffMerge"
    "Discord"
    "Docker"
    "Figma"
    "Mozilla Firefox"
    "GitHub Desktop"
    "Google Chrome"
    "Google Drive"
    "Hyper"
    "Insomnia"
    "iTerm"
    "LaunchControl"
    "Rectangle"
    "Sidekick"
    "Slack"
    "Sourcetree"
    "Spotify"
    "Stats"
    "Transmission"
    "Typora"
    "Visual Studio Code"
    "Warp"
    "Zoom.us"
)



# ------------------------------------------------------------------------------
rulemsg "MacOS default items + settings configuration"
# ------------------------------------------------------------------------------

get_consent "Create Dock spacers"
if has_consent; then
    PMSG "INFO" "Creating Dock spacers"
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    killall Dock
fi

get_consent "Autohide Dock"
if has_consent; then
    PMSG "INFO" "Autohiding Dock"
    defaults write com.apple.dock autohide -boolean true
    killall Dock
fi

get_consent "Display hidden Finder files/folders"
if has_consent; then
    PMSG "INFO" "Displaying hidden Finder files/folders"
    defaults write com.apple.finder AppleShowAllFiles -boolean true
    killall Finder
fi

if ! has_path "Developer"; then
    get_consent "Create ~/Developer folder"
    if has_consent; then
        PMSG "INFO" "Creating ~/Developer folder"
        mkdir -p ~/Developer
        test_path "Developer"
    fi
fi

if ! has_command "brew"; then
    PMSG "INFO" "Installing brew (Homebrew)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if has_arm; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew doctor
    brew tap homebrew/cask-fonts
    test_command "brew"
    export HOMEBREW_NO_AUTO_UPDATE=1
    PMSG "GOOD" "Homebrew Installed and Ready To Go!"
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Defaults Completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Tools setup + configurations"
# ------------------------------------------------------------------------------

if has_command "brew"; then
    if ! has_command "watchman"; then
        PMSG "INFO" "Installing watchman"
        brew install watchman
        test_command "watchman"
    fi
fi

if has_command "brew"; then
    if ! has_command "trash"; then
        PMSG "INFO" "Installing trash"
        brew install trash
        test_command "trash"
    fi
fi

if has_command "brew"; then
    if ! has_command "git"; then
        PMSG "INFO" "Installing git"
        brew install git
        test_command "git"
    fi
fi

if has_command "brew"; then
    if ! has_command "git-flow"; then
        PMSG "INFO" "Installing git-flow"
        brew install git-flow
        test_command "git-flow"
    fi
fi

if has_command "brew"; then
    if ! has_command "bash"; then
        PMSG "INFO" "Installing bash"
        brew install bash
        test_command "bash"
    fi
fi

if has_command "brew"; then
    if ! has_command "zsh"; then
        PMSG "INFO" "Installing zsh"
        brew install zsh
        test_command "zsh"
    fi
fi

if has_command "zsh"; then
    if ! has_path ".oh-my-zsh"; then
        PMSG "INFO" "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        test_path ".oh-my-zsh"
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "powerlevel10k"; then
        PMSG "INFO" "Installing powerlevel10k"
        brew install romkatv/powerlevel10k/powerlevel10k
        echo '# Theme configuration: PowerLevel10K' >>~/.zshrc
        echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
        echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' >>~/.zshrc
        echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >>~/.zshrc
        echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>~/.zshrc
        test_brew "powerlevel10k"
        p10k configure
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "zsh-autosuggestions"; then
        PMSG "INFO" "Installing zsh-autosuggestions"
        brew install zsh-autosuggestions
        echo "# Fish shell-like fast/unobtrusive autosuggestions for Zsh." >>~/.zshrc
        echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
        test_brew "zsh-autosuggestions"
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "zsh-syntax-highlighting"; then
        PMSG "INFO" "Installing zsh-syntax-highlighting"
        brew install zsh-syntax-highlighting
        echo "# Fish shell-like syntax highlighting for Zsh." >>~/.zshrc
        echo "# Warning: Must be last sourced!" >>~/.zshrc
        echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
        test_brew "zsh-syntax-highlighting"
    fi
fi

if has_command "brew"; then
    if ! has_command "node"; then
        PMSG "INFO" "Installing node"
        brew install node
        test_command "node"
    fi
fi

if has_command "brew"; then
    if ! has_command "n"; then
        PMSG "INFO" "Installing n"
        brew install n
        test_command "n"
    fi
fi

if has_command "brew"; then
    if ! has_command "nvm"; then
        PMSG "INFO" "Installing nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        test_command "nvm"
    fi
fi

if has_command "brew"; then
    if ! has_command "yarn"; then
        PMSG "INFO" "Installing yarn"
        brew install yarn
        test_command "yarn"
    fi
fi

if has_command "brew"; then
    if ! has_command "pnpm"; then
        PMSG "INFO" "Installing pnpm"
        brew install pnpm
        test_command "pnpm"
    fi
fi

if has_command 'npm'; then
    PMSG "INFO" "Upgrading npm"
    npm install --location=global npm@latest
    test_command "npm"
fi

if has_command "npm"; then
    PMSG "INFO" "Installing/Upgrading serve"
    npm install --location=global serve@latest
    test_command "serve"
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Tools completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Installing Applications/Casks"
# ------------------------------------------------------------------------------

if has_command "brew"; then
    for i in "${!app_name[@]}"; do
        DESC=${app_desc[$i]}
        NAME=${app_name[$i]}
        test_app "$DESC"
        if ! has_app "$DESC"; then
            PMSG "INFO" "Installing $NAME"
            brew install --cask $NAME
            test_app "$DESC"
        fi
    done
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Applications/Casks Install Completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Running Optimizations"
# ------------------------------------------------------------------------------

get_consent "Re-sort Launchpad applications"
if has_consent; then
    PMSG "INFO" "Re-sorting Launchpad applications"
    defaults write com.apple.dock ResetLaunchPad -boolean true
    killall Dock
fi

if has_command "zsh"; then
    if has_path ".oh-my-zsh"; then
        PMSG "INFO" "Updating oh-my-zsh"
        $ZSH/tools/upgrade.sh
        test_path ".oh-my-zsh"
    fi
fi

if has_command "brew"; then
    get_consent "Optimize Homebrew"
    if has_consent; then
        PMSG "INFO" "Running brew update"
        brew update
        PMSG "INFO" "Running brew upgrade"
        brew upgrade
        PMSG "INFO" "Running brew doctor"
        brew doctor
        PMSG "INFO" "Running brew cleanup"
        brew cleanup
    fi
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Optimizations complete"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Creating Homebrew Summary"
# ------------------------------------------------------------------------------

PMSG "GOOD" "$(uname -p) Architecture"
if has_path "Developer"; then
    PMSG "GOOD" "~/Developer"
else
    PMSG "WARN" "~/Developer"
fi

test_command "xcode-select"
test_command "brew"
test_command "watchman"
test_command "trash"
test_command "git"
test_command "git-flow"
test_command "zsh"
test_path ".oh-my-zsh"
test_brew "powerlevel10k"
test_brew "zsh-autosuggestions"
test_brew "zsh-syntax-highlighting"
test_command "node"
test_command "n"
test_command "nvm"
test_command "yarn"
test_command "pnpm"
test_command "npm"
test_command "serve"

test_app "Brave Browser"
test_app "DiffMerge"
test_app "Discord"
test_app "Figma"
test_app "Google Chrome"
test_app "Insomnia"
test_app "iTerm"
test_app "Rectangle"
test_app "Slack"
test_app "Sourcetree"
test_app "Spotify"
test_app "Visual Studio Code"
test_app "Warp"
test_app "Zoom.us"

# ------------------------------------------------------------------------------
PMSG "GOOD" "Summary complete"
# ------------------------------------------------------------------------------

PMSG "INFO" "Cleaning Up Homebrew"
brew cleanup
