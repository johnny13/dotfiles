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
