#!/usr/bin/env bash

source "../../installerbase.sh";

apt_or_brew_wp()
{
    APT_GET_CMD=$(command -v apt-get)
    BREW_CMD=$(command -v brew)

    if [[ ! -z $APT_GET_CMD ]]; then
        linuxWPCLIInstall
    elif [[ ! -z $BREW_CMD ]]; then
        macWPCLIInstall
    else
        echo "error can't install wordpress because cant determine OS type!"
        exit 1
    fi
}

linuxWPCLIInstall()
{
	echo "=============================="
	echo "wp cli - ianstall and add bash-completion for user www-data"
	echo "=============================="
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	php wp-cli.phar --info
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp
	wp --info
}

macWPCLIInstall()
{
	brew install wp-cli wp-cli-completion
	wp --info
}

## Start Script
rulemsg "INSTALL WP-CLI"

apt_or_brew_wp

lineEcho "DONE!"
echo ""