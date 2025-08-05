#!/usr/local/bin/bash

##
## CLI_HEADER.sh
##   Creates an few Ascii Art Banners from provided Text
##
## USAGE: cli_header.sh [text] [line|fancy] (version) (line character)
## NOTE: for line breaks, line or fancy must be explicitly set to one of those two values
## NOTE: set version to 0 if you dont want a version but do want custom line character
## NOTE: custom line character does not work with fancy linebreak
##

BLK="\e[0;30m" # Black
RED="\e[0;31m" # Red
GRN="\e[0;32m" # Green
YLW="\e[0;33m" # Yellow
BLU="\e[0;34m" # Blue
PUR="\e[0;35m" # Purple
CYN="\e[0;36m" # Cyan
WHT="\e[0;37m" # White

# BOLD TEXT COLORS
BBLK="\e[1;30m" # Black
BRED="\e[1;31m" # Red
BGRN="\e[1;32m" # Green
BYLW="\e[1;33m" # Yellow
BBLU="\e[1;34m" # Blue
BPUR="\e[1;35m" # Purple
BCYN="\e[1;36m" # Cyan
BWHT="\e[1;37m" # White

NORMAL="\e[0m"  # Text Reset
PRIMARY=$BGRN
ACCENT=$BCYN
SECONDARY=$BPUR

## GLOBALS
## -------
DEBUG=0
VER=0
DO_LOLCAT=0
LINEBREAK=0
LINEBREAKCHAR="-"
COLS=80
COLSSET=0
FONT=0
FIGFONT=0
SAVEPATH=""
SAVEFLAG=0
TEXTSTRING=""

fontarray=(Merlin1 Elite Graffiti Chunky Sub-Zero "ANSI Regular" Rounded cosmic)

## BUILD & DISPLAY (OR SAVE) BANNER
## ---------------------------------
function _hashes()
{
    printf -v _hr "%*s" "${COLS}" && echo -e "${ACCENT}${_hr// /${1--}}"
}

## Line Break
function linebreak()
                     {
    if [ "$VER" == "0" ]; then
        # OPTION ONE
        # Just print a line break
        if [ "$#" -eq 0 ]; then
            _hashes
        else
            _hashes "$1"
        fi
    else
        # OPTION TWO
        # Store Cursor.
        # Fill line with ruler character ($2, default "-")
        # Reset cursor
        # print version starting 20 spaces from Right
        # blankSpace=""
        # bSpace="${lineType}"
        # padRight=$((COLS - 40))
        # i=0
        # while [[ $i -lt $padRight ]]; do
        #     blankSpace="${blankSpace}${bSpace}"
        #     i=$((i + 1))
        # done

        if [ "$#" -eq 0 ]; then
            _hashes
        else
            _hashes "$1"
        fi

        padRight=$((COLS - 40))
        tput sc
        tput cuu1
        tput cuf "${padRight}"
        echo -e "${SECONDARY}[ v${VER} ]"
        tput rc
        echo -e "\n${NORMAL}"
    fi

}

## Very Cool Ascii Linebreak
function asciibar()
                    {

    echo -e "${ACCENT}  .--.      .--.     .--.      .--.      .--.      .--.      .--.      .--.      "

    centerBar="${SECONDARY}:::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::::::::.${ACCENT}\\\\${SECONDARY}::"

    if [ "$VER" != "0" ]; then
        centerBar="${centerBar}${ACCENT}[${SECONDARY} $VER ${ACCENT}]"
    fi

    echo -e "${centerBar}"
    echo -e "${ACCENT}       '--'      '--'      '--'      '--'      '--'      '--'      '--'      '   "
}

## Default Function to show all options
function printAllBanners()
                           {

    for i in "${fontarray[@]}"; do

        FIGFONT="${i}"
        echo -e "\nFONT: ${BRED}${FIGFONT}${NORMAL}"
        printFontBanner

    done
}

## -------------------------------
## Actual Workhorse of the script.
## Prints what you want printed.
## -------------------------------
function printFontBanner()
                          {

    if [ "$DO_LOLCAT" == 0 ]; then
        echo -e "\n\n${PRIMARY}"
        figlet -f "${FIGFONT}" -w "${COLS}" -c "${TEXTSTRING}"
        echo -en "\033[1A"
    else
        echo -e "\n\n"
        figlet -f "${FIGFONT}" -w "${COLS}" -c "${TEXTSTRING}" | lolcat
        echo -en "\033[1A"
    fi

    if [ "$LINEBREAK" == 1 ]; then
        if [ "$DO_LOLCAT" == 0 ]; then
            linebreak "${LINEBREAKCHAR}"
        else
            linebreak "${LINEBREAKCHAR}" | lolcat
        fi
    else
        if [ "$DO_LOLCAT" == 0 ]; then
            asciibar
        else
            asciibar | lolcat
        fi
    fi

    echo -e "\e[0m\n"

}

function saveFontBanner()
                          {
    printFontBanner >"$SAVEPATH"
}

## HELP, INFO & DEBUG FUNCTIONS
## ---------------------------------
function starterror()
                      {
    echo -e "\n\e[1;31mFAIL: You did not call this script correctly!\n"
    echo -e "\e[1;34mINFO:\e[0m \e[1;36mcli_header.sh\e[0m <params> text"
    echo -e "\e[1;32mText:\e[0m the text to print"
    echo
    echo -e "\e[1;36m________________ \e[1;34mPARAMS\e[0m \e[1;36m________________\n"
    echo -e "\e[1;32m-b --break\e[0m           line|fancy linebreak"
    echo -e "\e[1;32m-c --character\e[0m       Simple Linebreak character. defaults to -"
    echo -e "\e[1;32m-w --width\e[0m           Width of banner, defaults to terminal width"
    echo -e "\e[1;32m-n --version-number\e[0m  Version Number display on linebreak"
    echo -e "\e[1;32m-f --font\e[0m            Output specified font. defaults to all fonts"
    echo -e "\e[1;32m-s --save\e[0m            Save output to specified text file"
    echo -e "\e[1;32m-l --lolcat\e[0m          Pass final output through lolcat"
    echo -e "\e[0m"
    exit
}

## Debug Function. Prints all options
function setupdisplay()
                       {
    echo
    echo -e "\e[1;36m        - DEBUG MODE -\e[0m"
    echo
    echo -e "\t\e[1;32mVERSION:\e[0m ${VER}"
    echo -e "\t\e[1;32mLOLCAT:\e[0m ${DO_LOLCAT}"
    echo -e "\t\e[1;32mLINEBREAK:\e[0m ${LINEBREAK}"
    echo -e "\t\e[1;32mWIDTH:\e[0m ${COLS}"
    echo -e "\t\e[1;32mLINECHAR:\e[0m ${LINEBREAKCHAR}"
    echo -e "\t\e[1;32mFONT:\e[0m ${FIGFONT}"
    echo -e "\t\e[1;32mSAVEPATH:\e[0m ${SAVEPATH}"
    echo -e "\t\e[1;32mTEXT:\e[0m ${TEXTSTRING}"
    echo
}

## Initial Argument Parsing / Logic Controller
function startup()
                   {
    PARAMS=""
    while (("$#")); do
        case "$1" in
            -l | --lolcat)
                DO_LOLCAT=1
                shift
                ;;
            -d | --debug)
                DEBUG=1
                shift
                ;;
            -n | --version-number)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    VER=$2
                    shift 2
                else
                    echo "Error: Version number not given! Example: -n 0.0.0 " >&2
                    exit 1
                fi
                ;;
            -w | --width)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    COLS=$2
                    COLSSET=1
                    shift 2
                else
                    echo "Error: Width not set! Example: -w 100 " >&2
                    exit 1
                fi
                ;;
            -b | --break)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    LBT=$2
                    if [ "$LBT" == "line" ]; then
                        LINEBREAK=1
                        if [ "$COLSSET" == "0" ]; then
                            COLS="$(tput cols)"
                        fi
                    fi
                    if [ "$LBT" == "fancy" ]; then
                        LINEBREAK=2
                        COLS=80
                    fi
                    if [ "$LINEBREAK" == 0 ]; then
                        echo "Error: Incorrect value for Linebreak. Options are line or fancy" >&2
                        exit 1
                    fi
                    shift 2
                else
                    echo "Error: Linebreak not set! Example: -b line " >&2
                    exit 1
                fi
                ;;
            -c | --character)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    LINEBREAKCHAR=$2
                    shift 2
                else
                    echo "Error: Simple line character not set! Example: -c x " >&2
                    exit 1
                fi
                ;;
            -f | --font)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    FIGFONT=$2
                    FONT=1
                    shift 2
                else
                    echo "Error: Font not declared. Example: -f Chunky " >&2
                    exit 1
                fi
                ;;
            -s | --save)
                if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                    SAVEFLAG=1
                    SAVEPATH=$2
                    shift 2
                else
                    echo "Error: Output file not set. Example: -s my/path/file.txt " >&2
                    exit 1
                fi
                ;;
            -* | --*=) # unsupported flags
                echo "Error: Unsupported flag $1" >&2
                exit 1
                ;;
            *) # preserve positional arguments
                PARAMS="$PARAMS $1"
                shift
                ;;
        esac
    done
    # set positional arguments in their proper place
    eval set -- "$PARAMS"

    [ -z "$PARAMS" ] && echo -e "\n\e[1;31mFAIL: No text to output!\n\e[0m" && exit

    # Override check. Ignore width if fancy
    if [ "$LINEBREAK" == 2 ]; then
        COLS=80
    fi

    # Default check. Default to regular line
    if [ "$LINEBREAK" == 0 ]; then
        LINEBREAK=1
    fi

    # Cleanup Textstring
    TEXTSTRING=$(echo "$PARAMS" | xargs)

    if [ "$DEBUG" -eq 1 ]; then
        setupdisplay "$PARAMS"
    fi

    if [ "$FONT" -eq 0 ]; then
        printAllBanners
    else
        if [ "$SAVEFLAG" -eq 0 ]; then
            printFontBanner
        else
            saveFontBanner
        fi
    fi
}

if [ -z "$1" ]; then
    starterror
else
    startup "$@"
fi

exit
