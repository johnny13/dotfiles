export GIT_AUTHOR_NAME="Derek Scott"
export GIT_AUTHOR_EMAIL="derek@huement.com"

function ascii_banner()
{
	if [ $LINES -gt 30 ]; then
		file="${HOME}/.loginimg"
		if [ -f "$file" ]; then
			cat "${HOME}/.loginimg"
		else
			if ! command -v lolcatjs &>/dev/null; then
				ascii_text_banner
			else
				ascii_text_banner | lolcatjs
			fi
		fi
	else
		if ! command -v lolcatjs &>/dev/null; then
			ascii_text_banner
		else
			ascii_text_banner | lolcatjs
		fi
	fi
}

function ascii_text_banner()
{
	if [ $EUID -ne 0 ]; then
		## Create a little space and then: BAM! BANNER TIME!
		echo
		echo -e "\e[1;31m\e[1m       . .                  .,            .,,               .       .  "
		echo -e "\e[1;31m   !!!!!!!!!!!.!!!   .!  !!! !!!!!!;. !!!!!!!!!!!.!._.!!.   .!!!.   !!!. "
		echo -e "\e[1;31m   IIIIIIIIIII;III . III,III III^^III;IIIIIIIIII^III.'^'II,^ III,   III  "
		echo -e "\e[1;31m     ^  ||    ,|||,,,||| ||| |||,/|||^     ||     ||   .n||  |||||. |||  "
		echo -e "\e[0;31m        XX    -XXX***XXX,XXX XXXXXXc     . XX    -XX  = =XXX.XXX  YXcXX, "
		echo -e "\e[0;31m       .88,    888   *88 888 888b *88bo,   88,    88     888 888    Y88  "
		echo -e "\e[0;31m      --MMM    MMM    YM MXW WXMM    WWW. .MMM    MM YMMP00  MMM    -YM. "
	else
		echo
		echo -e "\e[1;36m                :::::::..       ...         ...   ::::::::::::  "
		echo -e "\e[1;36m                ;;;;^^;;;;   .;;;;;;;.   .;;;;;;;.;;;;;;;;;;;;  "
		echo -e "\e[1;36m                 III.!IIIi  .II     !II_ II     !II.   II       "
		echo -e "\e[0;36m                 XXXXxXXXc  XXX,     XXX XX,     XXX   XX       "
		echo -e "\e[0;36m                 888x i88Xo i888._ _.88X 888._ _.88X   88       "
		echo -e "\e[0;35m   .--.      .--.      .--.      .--.      .--.      .--.      .--.      .--.     "
		echo -e "\e[1;34m :::::.\::::::::.\::::::::.\::::::::.\::::::::.\::::::::.\::::::::.\::::::::.\::  "
		echo -e "\e[0;35m        '--'      '--'      '--'      '--'      '--'      '--'      '--'      '   "

	fi
}

function ascii_stats()
{

	## @TODO Ensure this only fires on linux
	# if ! command -v lsb_release &>/dev/null; then
	#     ## @TODO Ensure this only fires on linux
	#     uver="$(lsb_release --release | cut -f2)"
	#     ucon="$(lsb_release --codename | cut -f2)"
	#     echo -e "\e[91m                                                 v${uver} : ${ucon}"
	# fi

	M3N="$(date +%b)"
	DM="$(date +%d)"
	RN="$(lsb_release -rs)"
	CPUIDL="$(iostat --dec=0 -c | awk '/idle/{getline; print}' | awk '{ gsub(/ /,""); print }' | grep -o '..$')"
	CPUUSE="$((100 - CPUIDL))"
	CPUTMP="$(sensors -f | grep -A 0 '+' | cut -c1-23 | grep "Package id 0:" | cut -c15-23)"
	DISKFL="$(df -H --output=pcent . | tail -1 | awk '{ gsub(/ /,""); print }')"
	WIFIIP="$(hostname -I | cut -c1-12)"

	echo -e "\t  ${BWHT}${BB_BLK}██████████◤◢◤◢◤◢◤◢██████████◤◢◤◢██◤◢◤◢◤◢██◤ ◢◤ ◢◤ ◢◤ ◢██${NORMAL}"
	echo -e "\t  ${BWHT}▛▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▜${NORMAL}"
	echo -e "\t  ${BWHT}▘       ${BYLW}AVG CPU${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${CPUUSE}%  ${B}          ▝${NORMAL}"
	echo -e "\t  ${BWHT}▖       ${BYLW}CPU TMP${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${CPUTMP}   ${B}    ▗${NORMAL}"
	echo -e "\t  ${BWHT}▘       ${BYLW}HD USED${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${DISKFL}   ${B}         ▝${NORMAL}"
	echo -e "\t  ${BWHT}▖       ${BYLW}OS INFO${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${RN}       ${B}   ▗${NORMAL}"
	echo -e "\t  ${BWHT}▘       ${BYLW}WIFI IP${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${WIFIIP}   ${B}▝${NORMAL}"
	echo -e "\t  ${BWHT}▖       ${BYLW}CURRENT${BWHT}  ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ${BCYN} ${M3N} ${DM}${B}         ▗${NORMAL}"
	echo -e "\t  ${BWHT}▙▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▟${NORMAL}"
	echo " "
}

ascii_banner
ascii_stats
#ascii_stats | /home/lucky/.yarn/bin/lolcatjs

# if ! command -v lolcatjs &>/dev/null; then
# 	ascii_banner
# 	ascii_stats
# else
# 	ascii_banner
# 	ascii_stats | lolcatjs
# fi

notiSend()
{
	"${HOME}"/.local/rc/bin/notify-send -i "${HOME}"/.local/rc/icons/pumpkin.svg -u critical -a Huement "$1" "$2"
}
alias ns='notiSend'
