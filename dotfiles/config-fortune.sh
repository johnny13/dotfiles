#!/bin/bash
# ERIS | HACKINTOSH
# STOW CONFIG FILE

StowConfig=true
StowTargets=(
	"fortune"
	"fortune/config"
	"zshrc"
)

# Key Value Pair Option
declare -A arr
declare -A dirs

arr["fortune"]=/Users/fortune
arr["config"]=/Users/fortune/.config
arr["zshrc"]=/Users/fortune

dirs["fortune"]=/Users/fortune/Developer/tadot/dotfiles
dirs["config"]=/Users/fortune/Developer/tadot/dotfiles/fortune
dirs["zshrc"]=/Users/fortune/Developer/tadot/dotfiles