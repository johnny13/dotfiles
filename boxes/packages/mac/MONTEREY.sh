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
###############################################################################
# SSD-specific tweaks                                                         #
# You might want to disable these if you are not running an SSD               #
###############################################################################

# Disable local Time Machine snapshots
sudo tmutil disablelocal

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm -f /private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Set language and text formats
#defaults write NSGlobalDomain AppleLanguages -array "en"
#defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
#defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
#defaults write NSGlobalDomain AppleMetricUnits -bool false

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
#sudo systemsetup -settimezone "America/New_York" > /dev/null

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save screenshots to the Pictures/Screenshots
mkdir ${HOME}/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
#defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Tweak the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float .5

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
#defaults write com.apple.frameworks.diskimages skip-verify -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info at the bottom of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Set grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist

# Set the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 24" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 24" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 24" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
chflags nohidden ~/Library

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
#defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
#defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
#defaults write com.apple.dock showhidden -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
#   MENU_DEFINITION
#   MENU_CONVERSION
#   MENU_EXPRESSION
#   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
#   MENU_WEBSEARCH             (send search queries to Apple)
#   MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds >/dev/null  2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / >/dev/null
# Rebuild the index from scratch
sudo mdutil -E / >/dev/null

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &>/dev/null  && sudo tmutil disablelocal

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use `~/Documents/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Google Chrome" "Google Chrome Canary" "Mail" "Messages" \
    "Opera" "Safari" "SizeUp" "Spectacle" "SystemUIServer" \
    "Transmission" "Twitter" "iCal"; do
    killall "${app}" >/dev/null  2>&1
done

echo ""

ruleln "-" 60

echo ""
echo ""

finishEcho "SETTINGS DONE"

echo ""

echo "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."

pause
