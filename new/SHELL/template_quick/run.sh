#! /usr/bin/env bash

# ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
#                     ┳ ┳┳ ┓┳━┓┏┏┓┳━┓┏┓┓┏┓┓
#                     ┃━┫┃ ┃┣━ ┃┃┃┣━ ┃┃┃ ┃
#                     ┇ ┻┇━┛┻━┛┛ ┇┻━┛┇┗┛ ┇
# ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
#
# TITLE:    xSCRIPTNAMEx
# DETAILS:  xSCRIPTDETAILSx
# AUTHOR:   xAUTHOREMAILx
# VERSION:  xSCRIPTVERSIONx
# DATE:     xTODAYSDATEx
#
# ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔

## GLOBAL VARIABLES (Shouldnt need to change these)
scriptPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptFILENAME=$(basename "$0")
scriptFULLNAME="${scriptPATH}/${scriptFILENAME}"

# DESCRIPTION
# Executes the script.

# SETTINGS
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option()
                 {
  case $1 in
    'q') ;;
    *)
      printf "ERROR: Invalid option.\n"
                                       ;;
  esac
}
export -f process_option

# EXECUTION
while true; do
  if [[ $# == 0 ]]; then
    printf "\nUsage: run OPTION\n"
    printf "\nScript Options:\n"
    printf "  q: Quit/Exit.\n\n"
    read -r -p "Enter selection: " response
    printf "\n"
    process_option "$response"
  else
    process_option "$1"
  fi

  break
done
