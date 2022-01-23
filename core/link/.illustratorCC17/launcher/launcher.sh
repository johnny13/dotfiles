#!/usr/bin/env bash
if [ $# -ne 0 ];then
    echo "I have no parameters just run the script without arguments"
    exit 1
fi

notify-send "Illustrator CC" "Illustrator CC launched." -i "/home/lucky/.illustratorCC17/launcher/AiIcon.png"

SCR_PATH="/home/lucky/.illustratorCC17"
CACHE_PATH="/home/lucky/.cache/illustratorCC17"

WINE_PREFIX="$SCR_PATH/prefix"
 
export WINEPREFIX="$WINE_PREFIX"

wine64 "$SCR_PATH/IllustratorCC17/IllustratorCC64.exe"


