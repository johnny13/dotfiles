#!/usr/bin/env bash
#
# Simple menu

# Pause prompt.
# Suspend processing of script; display message prompting user to press [Enter] key to continue.
# $1-> Message (optional)

function pause() {
    local message="$@"
    [ -z "$message" ] && message="Press [Enter] key to continue:  "
    read -rp "$message" readEnterKey
}

# On-screen menu.

function show_menu() {
    date
    printf "%s\\n" "------------------------------"
    printf "%s\\n" "  Main Menu                   "
    printf "%s\\n" "------------------------------"
        printf "%s\\n" "  1. OPTION 1"
        printf "%s\\n" "  2. OPTION 2"
        printf "%s\\n" "  3. OPTION 3"
        printf "%s\\n" "  4. EXIT"
}

# Get input via keyboard and make a decision using: case...esac.

function read_input() {
    local c
    read -rp "Enter your choice [ 1-4 ]:  " c
    case $c in
        1) printf "%s\\n" "OPTION 1" ;;
        2) printf "%s\\n" "OPTION 2" ;;
        3) printf "%s\\n" "OPTION 3" ;;
        4) printf "%s\\n" "Ciao!"; exit 0 ;;
        *)
           printf "%s\\n" "Select an Option (1 to 4):  "

           pause
    esac
}

while true
do
    show_menu
    read_input
done
