#!/usr/bin/env bash

source "../../installerbase.sh";

composerBedrock()
{
	composer create-project roots/bedrock "$1"
	cd "$1"
	cp .env.example .env
	
	echo ""
	echo " ------------------"
	echo "   TODO:"
	echo "   Add in Response / Capture for ENV Values and replace them in file"
	echo " ------------------"
	echo ""
}

sageTheme()
{
	echo ""
	echo " ------------------"
	echo "   TODO:"
	echo "   Swap this to use the huement/salvia default theme"
	echo " ------------------"
	echo ""
	git clone https://github.com/roots/sage.git "$1/web/app/themes/salvia"
}

newDevSite()
{
	echo ""
	echo " ------------------"
	echo "   TODO:"
	echo "   Add in a virtual site for this blog"
	echo " ------------------"
	echo ""
}

## Start Script
rulemsg "SOPHISTICATED-TECHNOLOGY [soph-tech] WORDPRESS SETUP"

## name for wordpress install. If none, then using default
if [ -n "$1" ]; then
	_randomString 6
	DIR=$(pwd)
  BlogName="${DIR}/soph-${randomString}"
	PMSG "INFO" "Using Random Name soph-${randomString}"
else
	BlogName=$1
fi

PMSG "INFO" "Creating : ${BlogName}"
composerBedrock $BlogName

PMSG "INFO" "Adding default SALVIA theme to project"
sageTheme $BlogName

PMSG "INFO" "Updating VirtualHost Web URL"
newDevSite

lineEcho "DONE"
echo ""