#!/usr/bin/env bash

source "../../installerbase.sh";

apt_or_brew_wp()
{
    APT_GET_CMD=$(command -v apt-get)
    BREW_CMD=$(command -v brew)

    if [[ ! -z $APT_GET_CMD ]]; then
        linuxPHPCLIInstall
    elif [[ ! -z $BREW_CMD ]]; then
        macPHPCLIInstall
    else
        echo "error can't install wordpress because cant determine OS type!"
        exit 1
    fi
}

linuxPHPCLIInstall(){}

macPHPCLIInstall(){}

## Install PHP, MariaDB

## Configure MariaDB

## Copy over Adminer "db" folder