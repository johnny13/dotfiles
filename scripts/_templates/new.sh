#!/usr/bin/env bash
#/
#/ New Script Builder
#/
#/ Usage: ./new.sh
#/
#/ opts:
#/    -h|-?|--help)
#/       show this help and exit
#/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")"  >/dev/null 2>&1 && pwd)"
PROJECT="Script Template: Some Project thing..."

# COLOR OPTIONS
BRED="\e[1;31m" # Red
BBLU="\e[1;34m" # Blue
BGRN="\e[1;32m" # Green
BCYN="\e[1;36m" # Cyan
BWHT="\e[1;37m" # White
BPUR="\e[1;35m" # Purple
BYLW="\e[1;33m" # Yellow
NORMAL="\e[0m"  # Text Reset

function banner
{
    # Run this to generate the banner
    # figlet -f Rounded " E][AMPLE " | lolcat -f &> ban.txt
    # figlet -f rustofat " flacfixr " | lolcat -f &> ban.txt
    #
    # Then run this to create the final header
    # cat ban.txt divider.txt > header.txt
    echo
    cat header.txt
    echo
}

function die
{
  echo
  echo -e "${BRED}[FAIL]${NORMAL} $1"
  echo
  exit 1
}
function warn
{
  echo
  echo -e "${BYLW}[WARN]${NORMAL} $1"
  echo
}
function info
{
  echo
  echo -e "${BCYN}[INFO]${NORMAL} $1"
  echo
}
function good
{
  echo
  echo -e "${BGRN}[ OK ]${NORMAL} $1"
  echo
}
function show_help
{
  grep '^#/' "${BASH_SOURCE[0]}" | cut -c4- ||
    die "Failed to display usage information"
}

function _hashes
{
    HC=60;
    CS="-";
    echo -ne "${BWHT}${B_CYN}"
    printf %"$HC"s |tr " " "$CS"
    echo -ne "${NORMAL}\n\n"
}

function run_banner
{
    echo ""
    echo -e "${BCYN}$1${NORMAL}"
    _hashes "+" "${COLS}"
}

## SHOW BANNER
banner

## Bash Argument Parsing Example
## EXAMPLE: ./new.sh -a -b test
## -----------------------------
PARAMS=""
while (("$#")); do
    case "$1" in
    -a | --my-boolean-flag)
        MY_FLAG=0
        info "a flag"
        shift
        ;;
    -b | --my-flag-with-argument)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            MY_FLAG_ARG=$2
            shift 2
      else
            warn "Error: Argument for $1 is missing" >&2
            exit 1
      fi
        info "b: $MY_FLAG_ARG"
        ;;
    -h | -\? | --help) # help
      show_help
      exit
      ;;
    -* | --*=) # unsupported flags
        warn "Error: Unsupported flag $1" >&2
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

if [ $DEDUPE_FLAG -eq 0 ] && [ $SORT_FLAG -eq 0 ] && [ $PACK_FLAG -eq 0 ]; then
    show_help;
    die "No Options Passed!";
fi
