#!/usr/bin/env bash

#
# This file contains the command(s) to manually stow
# STOW ALL THE DIRECTORIES
#

echo ''
echo 'cd /Users/eris/Dotfiles/dotfiles'
echo 'stow --target=/Users/eris eris'
echo ''

cd '/Users/eris/Dotfiles/dotfiles'
stow --target=/Users/eris eris

echo ''
echo 'cd /Users/eris/Dotfiles/dotfiles/eris'
echo 'stow --target=/Users/eris/.config config'
echo ''

cd '/Users/eris/Dotfiles/dotfiles/eris'
stow --target=/Users/eris/.config config


## CLEANUP
if [ -d /Users/eris/config ]; then
  echo "Stow incorrectly created [/Users/eris/config]. Removing..."
  rm -rf /Users/eris/config
fi


echo ""
echo "All Done!"
echo ""