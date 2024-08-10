#!/bin/bash

#
# KEYBOARD ENABLE / DISABLE SCRIPT
# TAKEN FROM: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
#
# Uses xinput to disable laptop keyboard to use nicer keyboard overtop. 
#

Icon="~/.local/drbash/libraries/"
Icoff="/PATH_TO_ICON_OFF"
fconfig=".keyboard" 
id=11

if [ ! -f $fconfig ]; then
    echo "Creating config file"
    echo "enabled" > $fconfig
    var="enabled"
else
    read -r var< $fconfig
    echo "keyboard is : $var"
fi

if [ $var = "disabled" ]; then
    notify-send -i $Icon "Enabling keyboard..." \ "ON - Keyboard connected !";
    echo "enable keyboard..."
    xinput enable $id
    echo "enabled" > $fconfig
elif [ $var = "enabled" ]; then
    notify-send -i $Icoff "Disabling Keyboard" \ "OFF - Keyboard disconnected";
    echo "disable keyboard"
    xinput disable $id
    echo 'disabled' > $fconfig
fi
