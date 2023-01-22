#!/usr/local/bin/bash

. "/home/lucky/.local/rc/lib/libui-sh/libui-colors.sh"
. "/home/lucky/.local/rc/lib/libui-sh/libui.sh"

function shead
{
	echo -e "\n ${BGreen} ====================== \n"
	echo -e "\t${BCyan}${1}"
	echo -e "\n ${BGreen} ====================== ${Color_Off} \n"
}

function etxt
{
	echo -e "  ${BPurple}${1}${Color_Off}"
}

function ecmd
{
	echo -e "\n  ${BCyan} Running Command:\n\t${On_Purple}${BWhite}  > ${1}  ${Color_Off}\n\n"
}

echo ""
cat "/home/lucky/.local/rc/lib/sshuttle.txt"

echo -e "\n${On_Yellow}${BBlack}Mobile Hotspot Stealth | Evade Cellular ISP Throttling${Color_Off}"

# ===================================================
shead "TTL Settings"
etxt "Setting TTL Settings for iPV4 & iPV6"
sudo sysctl -w net.ipv4.ip_default_ttl=65
sudo sysctl net.ipv6.conf.all.hop_limit=65

#exit;

# ===================================================
shead "Mobile Hotspot Info"
echo " "
etxt "Grabbing Default Gateway IP Address (assuming you are connected to hotspot)"
ecmd "/sbin/ip route | awk '/default/ { print $3 }'"

DGIP=$(/sbin/ip route | awk '/default/ { print $3 }')
echo ""
etxt "Using IP: ${DGIP}"
echo ""
#ask_string "What is the Android Hotspot IP Address?"

# ===================================================
TERMUX_USER="u0_a337"
TERMUX_IP="${DGIP}"
TERMUX_PORT="8022"
LOCAL_SOCKS_PORT="8123"

shead "SSH Connection"
etxt "Pairing ${On_Green}${BWhite}[TERMUX ON ANDROID]${Color_Off}${BPurple} with Local Machine"
ecmd "ssh -D $LOCAL_SOCKS_PORT -fqgN $TERMUX_USER@$TERMUX_IP -p $TERMUX_PORT"

ssh -D $LOCAL_SOCKS_PORT -fqgN $TERMUX_USER@$TERMUX_IP -p $TERMUX_PORT

# ===================================================
shead "SSHuttle Startup"
etxt "Systemwide Transparent Proxy"
ecmd "sshuttle -r $TERMUX_USER@$TERMUX_IP:$TERMUX_PORT 0/0 -x $HOSTNAME -x 0/0"

sshuttle -r $TERMUX_USER@$TERMUX_IP:$TERMUX_PORT 0/0 -x $HOSTNAME -x 0/0
