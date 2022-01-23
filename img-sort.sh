#!/usr/bin/env bash

# COLOR OPTIONS
BRED="\e[1;31m" # Red
BBLU="\e[1;34m" # Blue
BGRN="\e[1;32m" # Green
BCYN="\e[1;36m" # Cyan
B_CYN="\e[1;46m" # Cyan
BWHT="\e[1;37m" # White
BPUR="\e[1;35m" # Purple
B_PUR="\e[1;45m" # Purple
BYLW="\e[1;33m" # Yellow
NORMAL="\e[0m"  # Text Reset

function banner
{
    # Run this to generate the banner
    # figlet -f Rounded " E][AMPLE " | lolcat -f &> ban.txt
    #
    # Then run this to create the final header
    # cat ban.txt divider.txt > header.txt
    echo -e "\n"
    cat "${DIR}/sort.txt"
    _hashes "+" "${COLS}"
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
    echo -e "${BYLW}[WARN]${NORMAL} $1"
}

function info
{
    echo -e "${BCYN}[INFO]${NORMAL} $1"
}

function good
{
    echo
    echo -e "${BGRN}[ OK ]${NORMAL} $1"
    echo
}

function _hashes
{
    HC=60
    CS="-"
    echo -ne "${BWHT}${B_CYN}"
    printf %"$HC"s | tr " " "$CS"
    echo -ne "${NORMAL}\n\n"
}

function run_banner
{
    echo ""
    echo -e "${BCYN}$1${NORMAL}"
    _hashes "+" "${COLS}"
}

function processFound
{
    ImgBN=$(basename "$1")
    EXT=$2
    BASE=$3     

    if [ -f "${BASE}/${EXT}/${ImgBN}" ]; then
        warn "${1} previously processed."
    else
        # We have found a valid image file
        info "Sorting ${ImgBN}"
        mkdir -p "${BASE}/${EXT}"
        #cp "$1" "${BASE}/${EXT}/${ImgBN}"
        rm "$1"
        DFD=$((DFD + 1))
    fi
}

function imgCategorically
{
    #local SearchDir

    SearchDir=$1
    run_banner "${SearchDir}/*.{EXTENSIONS}"

    for imgA in $SearchDir/*.{png,PNG,jpg,JPG,jpeg,JPEG}; do
        if [ -f "${imgA}" ]; then
            extA="RASTER"
            processFound "${imgA}" "${extA}" "${SaveDir}"
        fi
    done

    for imgB in $SearchDir/*.{eps,EPS,pdf,PDF,ai,AI}; do
        if [ -f "${imgB}" ]; then
            extB="VECTOR"
            processFound "${imgB}" "${extB}" "${SaveDir}"
        fi
    done

    for imgC in $SearchDir/*.{psd,PSD}; do
        if [ -f "${imgC}" ]; then
            extC="PHOTOSHOP"
            processFound "${imgC}" "${extC}" "${SaveDir}"
        fi
    done

    for imgD in $SearchDir/*.{svg,SVG}; do
        if [ -f "${imgD}" ]; then
            extD="SVG"dqp
            processFound "${imgD}" "${extD}" "${SaveDir}"
        fi
    done
}

echo -e "\n\nIMG SORT TEST\n\n"

DFD=0

IMGPATH="${1}"
SaveDir="${2}"

imgCategorically "${IMGPATH}"
imgCategorically "${IMGPATH}/*"
imgCategorically "${IMGPATH}/**/*"
imgCategorically "${IMGPATH}/**/**/*"
imgCategorically "${IMGPATH}/**/**/**/*"

echo -e "\n\n"
echo "${DFD} Files Processed!"
echo -e "\n\n"
