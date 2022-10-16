#!/usr/bin/env bash

sudo gpasswd -a $USER input

newgrp input

sudo apt-get install libinput-tools ruby xdotool fusuma

gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled

mkdir -p ~/.config/fusuma 

micro ~/.config/fusuma/config.yml
