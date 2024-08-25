#!/bin/bash
# ERIS | HACKINTOSH
# STOW CONFIG FILE

StowConfig=true
StowTargets=(
  "fortune"
  "zshrc"
)

# Key Value Pair Option
declare -A arr
declare -A dirs

arr["fortune"]=/Users/fortune
arr["zshrc"]=/Users/fortune

dirs["fortune"]=/Users/fortune/Developer/tadot/dotfiles
dirs["zshrc"]=/Users/fortune/Developer/tadot/dotfiles
