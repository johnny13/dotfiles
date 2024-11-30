#!/usr/local/bin/bash

source ./01_colors_esc.sh
source ./01_colors_tput.sh

echo ""
echo "  ${BGRN}Downloading video ${1}${NORMAL}"
echo ""

yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 "https://www.youtube.com/watch?v=$1"

 echo ""
 echo "${BGRN}       All Done! ${NORMAL}"
 echo ""
