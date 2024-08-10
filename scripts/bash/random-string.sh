#!/usr/bin/env bash

if [ $# -eq 0 ]; then
	AMOUNT=13
else
	AMOUNT=${1}
fi

LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c ${AMOUNT}; echo
