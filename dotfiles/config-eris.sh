#!/bin/bash
# ERIS | HACKINTOSH
# STOW CONFIG FILE

StowConfig=true
StowTargets=(
"eris"
"eris/config"
)
	
# Key Value Pair Option
declare -A arr
declare -A dirs

arr["eris"]=/Users/eris
arr["config"]=/Users/eris/.config

dirs["eris"]=/Users/eris/Dotfiles/dotfiles
dirs["config"]=/Users/eris/Dotfiles/dotfiles/eris