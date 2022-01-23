##   BASH ALIASES
##  .:.:.:.:.:.:.:.

alias rl='rofi -show window -theme base16-tomorrow-night-eighties'

## NETWORK & WIFI
## -----------------
get-ip-info()
             {
    WAN=$(ip -c -o -p -j address show dev wlp2s0 scope global | jq -C -S '.[0].addr_info | .[0].local' | xargs)
    LAN=$(ip -c -o -p -j address show dev wlp2s0 scope global | jq -C -S '.[0].addr_info | .[1].local' | xargs)
    echo -e "\n${BBLU}  -* ${BPUR}WIFI IP INFO${BBLU} *-\n ${BYLW}xoxoxoxoxoxoxoxoxoxo${NORMAL}\n\n"
    echo -e "${BCYN}  WAN${BWHT} : ${BGRN}${WAN}${NORMAL}\n"
    echo -e "${BCYN}  LAN${BWHT} : ${BGRN}${LAN}${NORMAL}\n\n"
}

alias ipaddy='get-ip-info'
alias wifi-off='sudo ip link set dev wlp2s0 down'
alias wifi-on='sudo ip link set dev wlp2s0 up'

setupWifi()
           {
    echo -e "\n\n${BCYN}Starting PCI-e WIFI....\n${NORMAL}${WHT}${BB_GRN}[ + ]${NORMAL}${BCYN} NetworkManager Starting\n"
    sudo NetworkManager
    echo -e "${NORMAL}${WHT}${BB_GRN}[ + ]${NORMAL}${BCYN} nmcli set mode managed"
    sudo nmcli device set wlp2s0 managed yes
    echo -e "${NORMAL}${WHT}${BB_GRN}[ + ]${NORMAL}${BCYN} nmcli set autoconnect yes"
    sudo nmcli device set wlp2s0 autoconnect yes
    echo -e "\n${NORMAL}${BWHT}${BB_GRN}[OK!]${NORMAL}${BGRN} PCI-e Wifi Card: ${BB_WHT}${BPUR} [ ACTIVE ] ${NORMAL}\n"
    echo -e "\n\n"
    nmcli -f GENERAL,WIFI-PROPERTIES dev show wlp2s0
}

alias wifi-card='setupWifi'
alias wifi-lan='sudo arp-scan --interface wlp2s0 --localnet'
alias wifi-ip='ifconfig wlp2s0 | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'
alias wifi-scan='sudo iwlist wlp2s0 scan'

alias python='/usr/bin/python3'

alias mkdv='glow'
alias mdtoc='doctoc'

alias pbcopy='xclip -sel clip'

alias yaml2json="python -c 'import sys, yaml, json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'"

###
## PACKAGES
###

# Count total packages
alias packages-total='dpkg -l | wc -l'
# display list of all packages
alias packages-list='dpkg --get-selections | grep -v deinstall'
# export packages list
alias packages-list-export='sudo apt list --installed > packages.txt'
# uninstall packages from list
alias packages-list-remove='sudo apt -y remove $(cat packages.txt)'
# install packages from list
alias packages-list-install='sudo apt -y install $(cat packages.txt)'

## [fonts] Reset font cache
alias font-reset='fc-cache -f -v'

##  [wget] CLI Downloading
# Save a website for local viewing
alias wget-website='wget -mkp'
alias wget-file='wget --no-check-certificate --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" -c --progress=dot'
alias wdown='wget -c --progress=dot'

alias services-all='systemctl list-units --type=service'
alias services-running='systemctl list-units  --type=service  --state=running'

alias tree='alder -s -D --exclude="node_modules|.git"'

alias m='micro'
alias k='kanban'

alias git-info-fetch='cd ~/Developer/dr_bash && onefetch'

alias openg='xdg-open'
alias open='xdg-open'

###
## CAT ALIASES
###

alias catmd='glow'

function _catjson()
                   {
    cat $1 | pjson
}
alias catjson='_catjson'

alias catimg='viu -t -n -r'

###
## LIST ALIASES
###

alias lsdisk='df -x squashfs --total -h'
alias lsdf='df -x squashfs --total -h'

alias lsimg='pqiv -cFl --browse --recreate-window --low-memory --enforce-window-aspect-ratio'
alias lspic='pqiv -cFl --browse --recreate-window --low-memory --enforce-window-aspect-ratio'

alias lsdir='exa -D -G -h -H -s new -r -l --git-ignore'

alias lsfiles='ls -p | grep -v / | column'

### ## ###
alias cpu-max='sudo cpupower frequency-set --governor performance'

alias play='/home/lucky/.local/bin/sound-board.bash'

alias neofetch='macchina -U -b -p -S -s 2'

# BASH HELPER
alias rebash='clear && source /home/${USER}/.bashrc'
alias alias-edit='micro -filetype shell ~/.bash_aliases'
