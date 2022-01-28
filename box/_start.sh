###
### UI FUNCTIONS
###

banner()
{
    echo -e "${BPUR}"

    cat <<EOF


                          0000000..   .,-00000
                          ||||^^||||,|||*^^^^*
                          [[[,/[[[* [[[
                          XXXXXxx   XXX
                          888b ^88bo*88bo.__.o
EOF

    echo -en "${BCYN}"

    cat <<EOF
  .--.      .--.      .--. .+----------------+.   .--.      .--.      .--.
:::::.\::::::::.\::::::::.| RESEARCH CHEMICALS |:::::.\::::::::.\::::::::.\::
       '--'      '--'      '+----------------+'        '--'      '--'      '

EOF
    echo -e "${NORMAL}"

}

taskName()
{
    STATS=$( date +'%I:%M.%S')
    printf "
${BPurple}◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼
${NC}\t 🎃 ${BGRN}${STATS} ${BCYN}❱❱  ${BWhite} $1
${BPurple}◼ ◼ ◼ ◼ ◼  ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼ ◼${NC}"
}

taskStatus()
{
    echo -e "\n\t${BCYN}•••━ • ━•${BBLU}❪ ${BWHT}$1 ${BBLU}❫${BCYN}━━ • ━━${BPUR}[ ${BWHT}$2 ${BPUR}] ❱${NORMAL}\n"
}

lineBreak()
{
    echo -e "\n\t${BYLW}•••••\t${BGRN}•••••\t${BBLU}•••••\t${BPUR}•••••\t${BRED}•••••\n${NORMAL}"
}

finishEcho()
{
    echo -e "\n\t${BGRN}━━━━━━▶ $1 FINISHED!\n${NORMAL}\n\n"
}

logFileLineBreak()
{
    STATS=$( date +'%I:%M.%S')
    echo -e "\n\n" >> ${LOGFILE}
    echo -e "•• ━━━━━━━━ • ━━━ • [ ${STATS} ] ━━━ • ━━ •" >> ${LOGFILE}
    echo -e "\n" >> ${LOGFILE}
}

# Checks if a command is installed
_hasCMD()
{
    if ! command -v $1 &>/dev/null; then
        #echo "${1} could not be found"
        return 1
    else
        return 0
        #echo "${1} was found"
    fi
}

###
### RUN SCRIPT
###

banner

sleep 2

# 	Display 5 seconds count down before script executes
for i in $(seq 5 -1 1); do
    echo -ne "$i\rGetting ready to proceed with the automation in... "
    sleep 1
done
