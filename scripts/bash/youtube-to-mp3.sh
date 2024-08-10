#!/usr/local/bin/bash

echo ""
echo "  ${BGRN}Downloading video ${1}${NORMAL}"
echo ""

 #https://www.youtube.com/watch?v=GNp4y9yp1uc

 youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0 $1

 echo ""
 echo "${BGRN}       All Done! ${NORMAL}"
 echo ""
