#!/usr/bin/env bash

#/ ---------------------------------------------------------------
#/  || [R]ESEARCH [C]HEMICALS - injectable shell augmentations ||
#/ ---------------------------------------------------------------
#/
#/ Usage: ./RUN.sh
#/
#/ Select option from menu:
#/
#/    -h | --help)
#/       show this help and exit
#/
#/	  1 - X)
#/		Executes various parts of the builder.
#/		Run w/ no params for detailed breakdown of each option.
#/
#/ ------------------ ---------  ------   ----    ---     --      -
#| Version 0.1.1

##
## Libraries & Globals
## -------------------------
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "${BASEDIR}" || exit

source ./.run/ansi
source ./.run/helpers.sh
source ./.run/helpers_fs.sh
# source ./.run/actions.sh
source ./.run/actions-new.sh

#. "./.run/libui.sh"

# [R]un [A]s [R]oot?
RAR="false"

## GLOBAL VARIABLES (Shouldnt need to change these)
scriptPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptFILENAME=$(basename "$0")
scriptFULLNAME="${scriptPATH}/${scriptFILENAME}"

## READS FROM THE COMMENTS AT THE TOP OF THE FILE
usage()
{
    grep '^#/' "${BASH_SOURCE[0]}" | cut -c4- ||
        die "Failed to display usage information"
    echo ""
    exit 0
}

version()
{
    grep '^#|' "${BASH_SOURCE[0]}" | cut -c4- ||
        die "Failed to display version information"
    echo ""
    exit 0
}

## Ascii Banner. Change as desired.
menuheader()
{
    #x HEADERCODE
    # shellcheck disable=SC2317
    echo "${scriptFILENAME}"
}

# Exit Script
# -----------------------------------
# Non destructive exit for when script exits naturally.
# Usage: Add this function at the end of every script
# -----------------------------------
safeExit()
{
    local tmpDir
    tmpDir="${BASEDIR}/temp"

    # Delete temp files, if any
    if is_dir "${tmpDir}"; then
        rm -r "${tmpDir}"
    fi
    trap - INT TERM EXIT
    exit
}

##
## MENU DISPLAY
## -------------------------

echoMenuBG()
{
    ansi::eraseDisplay 2
    ansi::position "1;1"
    ansi::down 2
    #ansi::bgBlack
    ansi::color 77
    cat "./.run/bg.txt"

    ansi::up 24
}

echoMenuItem()
{
    ansi::color 45
    echo "   ${1}"
    echo " "
    ansi::resetForeground
    ((rcC++))
}

echoMenuRow()
{
    echo ""
    ansi::forward $2
    ansi::color 11
    echo -e "$1"
    ansi::resetForeground
}

echoChoiceSelect()
{
    ((rcC--))
    local option
    ansi::bold
    ansi::color 11
    echo -e "\tENTER CHOICE TO CONTINUE [?]"
    read -n 1 -s option </dev/tty
    case "$option" in
        1)
            echoMiniHeader
			cleanFiles $scriptPATH
            gitAutoCommit
            pause
            echoMainMenuDisplay
            ;;
        i)
            echoMiniHeader
            testFunction
            pause
            echoMainMenuDisplay
            ;;
        k)
            echoMiniHeader
            echo "TODO: ADD Functions"
            echo "todo: pixel art tools"
            echo "delta diff fuzzy-sys kanban board"
            pause
            echoMainMenuDisplay
            ;;
        l)
            echoMiniHeader
            # list stowed files
			${BASEDIR}/stowCMD.sh --list
            pause
            echoMainMenuDisplay
            ;;
        s)
            echoMiniHeader
            # stow command
			${BASEDIR}/stowCMD.sh
            pause
            echoMainMenuDisplay
            ;;
        t)
            echoMiniHeader
            # setup / testFunction
			${BASEDIR}/stowCMD.sh --setup
            pause
            echoMainMenuDisplay
            ;;
        x)
            echoMiniHeader
            keyboardHelp
            pause
            echoMainMenuDisplay
            ;;
        h)
            usage
            ;;
        q)
            clear
            # uncomment for cool exits
            # ${BASEDIR}/rice/ascii-art/see_you.sh
            # sleep 1 # Waits 5 seconds.
            # clear
            safeExit
            ;;
        *)
            echo -e "${BRED}     Bad choice!!!${NORMAL}\n\n" && exit
            ;;
    esac
    echo ""
}

echoMiniHeader()
{
    clear
    ansi::color 11
    cat "${BASEDIR}/.run/bg_sm.txt"
    echo ""
    ansi::resetForeground
}

echoMenuClearOut()
{
    echo -e "\n\n"
    ansi::down 13
    ansi::resetForeground
    ansi::normal
    ansi::resetBackground
    echo ""
}

echoMainMenuDisplay()
{
    # Clear Screen & Display Background
    echoMenuBG

    ((rcC = 1))

    ## Main Menu Categories
    ## -------------------------
    echo ""
    echoMenuRow "▰▱❪❮ TADOT CMD ❯❫▰▱▱▰" 8
    echo ""

    for i in "${coreItem[@]}"; do
        ansi::forward 7
        echoMenuItem "${i}"
    done

    ansi::up 9

    echoMenuRow "▰▱❪❮ +CLI CMDS ❯❫▰▱▱▰" 36
    echo ""

    for i in "${cliItem[@]}"; do
        ansi::forward 35
        echoMenuItem "${i}"
    done

    ansi::down 2

    echoMenuRow "▰▱❪❮ REPO CMDS ❯❫▰▱▱▰" 8
    echo ""

    for i in "${initItem[@]}"; do
        ansi::forward 7
        echoMenuItem "${i}"
    done

    ## Finish Main Menu
    ## -------------------------
    ansi::down 10

    echoChoiceSelect

    ansi::resetForeground
    ansi::normal
    ansi::resetBackground

    echo -e "\n"
}

##
## Declare Menu Items
## -------------------------
declare -a coreItem=("[t] setup / test" "[s] run gnu stow" "[l] list stowd files")
declare -a cliItem=("[x] cheat sheet" "[ ] todo")
declare -a initItem=("[1] gitAutoCommit")

##
## Start Script / Main Menu
## -------------------------

while true; do
    echoMainMenuDisplay
done

safeExit
