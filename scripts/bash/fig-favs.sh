#!/usr/local/bin/bash

nvm use default

BBLK="\e[1;30m" # Black
BRED="\e[1;31m" # Red
BGRN="\e[1;32m" # Green
BYLW="\e[1;33m" # Yellow
BBLU="\e[1;34m" # Blue
BPUR="\e[1;35m" # Purple
BCYN="\e[1;36m" # Cyan
BWHT="\e[1;37m" # White
# BOLD BACKGROUND
BB_BLK="\e[1;40m" # Black
BB_RED="\e[1;41m" # Red
BB_GRN="\e[1;42m" # Green
BB_YLW="\e[1;43m" # Yellow
BB_BLU="\e[1;44m" # Blue
BB_PUR="\e[1;45m" # Purple
BB_CYN="\e[1;46m" # Cyan
BB_WHT="\e[1;47m" # White
# COLOR OPTIONS
NORMAL="\e[0m"    # Text Reset

echo ""
echo -e "${BCYN}█████████████████████████████████████████████████████████████████████████████████████████"
echo "                                                                                         "
echo -e "${BGRN}                      ███████████ █████ █████ ███████████ █████ █████                    "
echo -e "${BGRN}                     ░█░░░███░░░█░░███ ░░███ ░█░░░███░░░█░░███ ░░███                     "
echo -e "${BCYN}██████████████████${BGRN}   ░   ░███  ░  ░░███ ███  ░   ░███  ░  ░░███ ███    ${BCYN}██████████████████"
echo -e "${BCYN}██████████████████${BGRN}       ░███      ░░█████       ░███      ░░█████     ${BCYN}██████████████████"
echo -e "${BCYN}██████████████████${BGRN}       ░███       ███░███      ░███       ░░███      ${BCYN}██████████████████"
echo -e "${BCYN}██████████████████${BGRN}       ░███      ███ ░░███     ░███        ░███      ${BCYN}██████████████████"
echo -e "${BGRN}                         █████    █████ █████    █████       █████                       "
echo -e "${BGRN}                        ░░░░░    ░░░░░ ░░░░░    ░░░░░       ░░░░░                        "
echo "                                                                                         "
echo -e "${BCYN}█████████████████████████████████████████████████████████████████████████████████████████"
echo -e "${NORMAL}"

array=(Merlin1 Graffiti Chunky Sub-Zero Modular Rounded cosmic drpepper "Nancyj-Fancy" "3D-ASCII" gangshit2 cholo1 Crazy "Stronger Than All" philly "Star Wars")
for i in "${array[@]}"; do
	echo -e "${BYLW}  --| ASCII: ${BBLU}${i} ${BYLW}|--"
	echo -e "${BPUR}  figlet -f \"${i}\" \"${i}\" ${NORMAL}"
	figlet -w 120 -c -f "${i}" "${i}" | lolcatjs
	echo " "
	echo " "
done

echo ""
echo ""
echo -e "${BBLU}xxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][XxxxxxxX][Xxxx${NORMAL}"
echo ""
echo ""

array=(Elite "DOS Rebel" Bloody Electronic "ANSI Regular" "ANSI Shadow" maxiwi miniwi rustofat pagga smmono12 future)
for i in "${array[@]}"; do
	echo -e "${BYLW}  --|  ANSI: ${BBLU}${i} ${BYLW}|--"
	echo -e "${BPUR}  figlet -f \"${i}\" \"${i}\" ${NORMAL}"
	figlet -w 120 -c -f "${i}" "${i}" | lolcatjs
	echo " "
	echo " "
done

echo -e "${NORMAL}"
echo -e "                                    ${BPUR}--- fin ---${NORMAL}"
echo ""
