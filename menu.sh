#!/usr/bin/env bash

#/ -----------------------------------------
#/ | [R]ESEARCH [C]HEMICALS - cli on drugs |
#/ -----------------------------------------
#/
#/ Usage: ./menu.sh
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
#| Version 0.0.1

##
## Libraries & Globals
## -------------------------
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "${BASEDIR}"

. "./_lab/ansi"
. "./_lab/helpers.sh"
. "./_lab/helpers_fs.sh"
. "./_lab/actions.sh"

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
    #ansi::bgBlack
    ansi::color 77
    cat "./_lab/bg.txt"

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
    echo -e "\n\n\tENTER LETTER TO LAUNCH COMMAND [?]\n\n"
    read -n 1 -s option </dev/tty
    case "$option" in
        b)
            echoMiniHeader
            buildBashRC
            #echoMenuClearOut
            pause
            echoMainMenuDisplay
            ;;
        d)
            echoMiniHeader
            #initializeRC
            dotfileCOPY
            dotfileLINK
            dotfileMEDIA
            pause
            echoMainMenuDisplay
            ;;
        s)
            echoMiniHeader
            shellScriptBinaryConversion "${BASEDIR}/core/sh"
            addLocalProfileSH
            clearOutTempShellScripts
            pause
            echoMainMenuDisplay
            ;;
        n)
            echoMiniHeader
            createNewShellScript
            pause
            echoMainMenuDisplay
            ;;
        1)
            echo "status report"
            ;;
        x)
            echoMiniHeader
            keyboardHelp
            pause
            echoMainMenuDisplay
            ;;
        p)
            echo "pixel art"
            ;;
        k)
            echo "delta diff"
            echo "fuzzy-sys"
            echo "kanban board"
            ;;
        r)
            echoMiniHeader
            boxInstallScripts
            pause
            echoMainMenuDisplay
            ;;
        8)
            echoMiniHeader
            echo "TODO:Backup Installed APT packages."
            pause
            echoMainMenuDisplay
            ;;
        h)
            usage
            ;;
        g)
            echoMiniHeader
            gitCommit
            pause
            echoMainMenuDisplay
            ;;
        q)
            clear
            #/bin/bash ./media/ascii/see_you.sh
            figlet -f gangshit2 -w 150 -ksS "Later" | lolcat -a -d 2 -s 60
            sleep 1s # Waits 5 seconds.
            clear
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
    cat "./_lab/bg_sm.txt"
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
    echoMenuRow "▰▱❪❮ CORE ITEMS ❯❫▰▱▱▰" 8
    echo ""

    for i in "${coreItem[@]}"; do
        ansi::forward 7
        echoMenuItem "${i}"
    done

    ansi::up 11

    echoMenuRow "▰▱❪❮ CLI  APPS ❯❫▰▱▱▰" 36
    echo ""

    for i in "${cliItem[@]}"; do
        ansi::forward 35
        echoMenuItem "${i}"
    done

    ansi::down 2

    echoMenuRow "▰▱❪❮ INSTALL RC ❯❫▰▱▱▰" 8
    echo ""

    for i in "${initItem[@]}"; do
        ansi::forward 7
        echoMenuItem "${i}"
    done

    ## Finish Main Menu
    ## -------------------------
    ansi::down 24

    echoChoiceSelect

    ansi::resetForeground
    ansi::normal
    ansi::resetBackground

    echo -e "\n\n"
}

##
## Declare Menu Items
## -------------------------
declare -a coreItem=("[b] build .bashrc" "[d] dotfile sync" "[s] shell scripts" "[1] status report")
declare -a cliItem=("[x] Keyboard Help" "[k] CLI Apps" "[p] Pixel Art" "[n] new .sh script")
declare -a initItem=("[8] box backup" "[r] rebuild box scripts" "[g] git commit help")

##
## Start Script / Main Menu
## -------------------------

while true; do
    echoMainMenuDisplay
done

safeExit
