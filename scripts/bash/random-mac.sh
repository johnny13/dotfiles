#!/usr/local/bin/bash

##
## [DESC] Automatically generates random legal mac address
## [VERS] 2.0
## [DATE] 2020-07-23
## [LINK]
##
## [CMND] ./random_mac.sh [number]
## [OPTS] number (optional amount of addresses to generate)
##

function generate_random_mac()
{
	i=0
	macMax=$1

	while [[ $i -lt $macMax ]]; do
		random=$(hexdump -n6 -e '/1 ":%02x"' /dev/urandom)
		if echo $random | grep -q '*'; then
			continue
		fi
		octet=$(echo $random | cut -d : -f2)
		shi=$((0x${octet}))
		flag=$(($shi % 2))
		if [ $flag -eq 0 ]; then
			mac=$(echo $random | sed 's/^://g')
			echo $mac
			i=$((i + 1))
		fi
	done
}

if [ -z "$1" ]; then
	macAddyMax=1
else
	macAddyMax=$1
fi

generate_random_mac macAddyMax
