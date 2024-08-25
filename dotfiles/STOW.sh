#!/usr/bin/env bash

#/ Simple script to run all the required GNU Stow commands
#/ Options are sent via config file
#/ One feature of this file is it will automatically clear out any problem files, like ".DS_Store" files on MacOS
#/ It also allows for a list of key value pairs to control what directories are stowed, allowing for better control over gnuSTOW
#/ without having to remember all the commands and what directory those commands must be ran from.

#/ Usage is very simple. Make sure your config values are set for your username. ie 'config-${user}.sh'
#/ $ ./STOW.sh

## When active, script echos commands instead of running them.
# DRYMODE=true

## GLOBAL VARIABLES (Shouldnt need to change these)
scriptPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptFILENAME=$(basename "$0")
scriptFULLNAME="${scriptPATH}/${scriptFILENAME}"

# SETTINGS
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# Get Username
USER=$(whoami)
USERFILE="config-${USER}.sh"
echo "${USER} | Running Dotfiles Stow Command"

# Get configFile[Username]
if test -f "${scriptPATH}/${USERFILE}"; then
	echo "${USER} | Loading Config File ${scriptPATH}/${USERFILE}"
	source "${scriptPATH}/${USERFILE}"
fi

if [[ -z $StowTargets ]]; then
	echo "${USER} | No Stow Targets found in config"
	exit 1
else
	echo "${USER} | Stowing ${#StowTargets[@]} Packages"

	cd "${scriptPATH}"
	find . -name ".DS_Store" -delete

	counter=1
	#   for i in "${StowTargets[@]}"
	# 	do
	# 	   echo "${USER} | #${counter}. Stow Target: $i"
	#
	# 	   if [[ -z $DRYMODE ]]; then
	# 		   echo 'DO IT FOR REAL'
	# 	   else
	# 		   # change to the array item's directory
	# 		   echo "DRY| cd ${scriptPATH}"
	# 		   echo 'DRY stow --target=/Users/eris eris'
	# 	   fi
	# 	done

	for key in ${!arr[@]}; do
		cd "${dirs[${key}]}"
		find . -name ".DS_Store" -delete

		if [ -z ${DRYMODE+x} ]; then
			echo "STOW #${counter} | ${scriptPATH}/${key}"
			stow --target="${arr[${key}]}" "${key}"
		else
			echo "DRY #${counter}| stow --target=${arr[${key}]} ${key}"
		fi

		((counter++))
	done
fi

## read target directory in variable

## read directories into array

# grab $filename from 1st directory for confirmation later

# foreach directory -> run stow --target=$target $dir

# Confirm simlink exists at $target/$filename

## CLEANUP
if [ -d /Users/eris/config ]; then
	echo "Stow incorrectly created [/Users/eris/config]. Removing..."
	rm -rf /Users/eris/config
fi

echo ""
echo "All Done!"
echo ""

# echo "${USER} | Running Dotfiles Stow Command"
#
# echo ''
# echo 'stow --target=/Users/eris/.config/zsh zsh'
# echo 'stow --target=/Users/eris/.config starship.toml'
# echo ''
