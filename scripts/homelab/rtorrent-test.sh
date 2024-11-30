#!/bin/bash

# !!! This dance assumes you are logged into the console as the user who is having the issues.
# If necessary, use the su or sudo su commands to switch he user.
NAME="derek"

# Stop rtorrent if it is currently running in some odd state.
sudo systemctl stop rtorrent@$NAME
#Check there are no screen sessions running for rtorrent
screen -ls
# Verify there is no other random rtorrent process running
ps x | grep rtorrent
# Check if the lock file exists
find ~ -name "*rtorrent.lock"
# Remove the file that prevents the startup
rm ~/.sessions/rtorrent.lock # Or whatever the path was that returned above
#Verify that rtorrent can start successfully
rtorrent
# Quit the rtorrent 
# <Press CTRL+q>
# Start the rtorrent service
sudo systemctl start rtorrent@$NAME
# check the output
systemctl status rtorrent@$NAME
# See if you can attach the screen with rtorrent
screen -r rtorrent
# !!! DETACH from the screen
# <Press CTRL+a (release) d>