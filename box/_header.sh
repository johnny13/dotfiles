#!/usr/bin/env bash

# if [ "$EUID" -ne 0 ]; then
#          echo "Please run as root"
#     exit 1
# fi

set -e
set -o pipefail

traperr()
          {
    echo "ERROR: ${BASH_SOURCE[1]} at about ${BASH_LINENO[0]}"
}

set -o errtrace
trap traperr ERR

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

LOGFILE='fresh-install-log'
