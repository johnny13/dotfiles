#!/bin/bash
#/ Sort downloaded images into one optimized folder.
#/
#/ Usage: ./img_sort.sh
#/
#/ opts:
#/    -s|--sort <DIR>)
#/       Sort the images in given Directory
#/    -p|--pack)
#/       Package the end result into a .zip archive
#/    -d|--dedupe)
#/       Remove any duplicates (requires 'fdupes' package)
#/    -h|-?|--help)
#/       show this help and exit
#/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")"  >/dev/null 2>&1 && pwd)"
PROJECT="Sort a bunch of random folders recursively into one directory w/ only the image files."

cd "${DIR}"

## CUSTOMIZE THIS PART
XV="~/Pictures/WebDownloads"
ZIP="~/Pictures"
## END CUSTOMIZE

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

function show_help
{
    grep '^#/' "${BASH_SOURCE[0]}" | cut -c4- ||
        die "Failed to display usage information"
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

########
######## FUNCTIONS
########

function packItUp
{
    info "Compressing Files in: $1"
    zip -r "${ZIP}/images.zip" "$1"
    good "Archive Created!"
    ls -l "$1" | grep .zip
    mfs=$(du --apparent-size --block-size=1  "${ZIP}/images.zip" | awk '{ print $1}')
    info "Zip Archive Size: ${mfs}"
}

function removeDupes
{
    info "Searching Files in: $1"
    BEFORE=$(ls "$1" | wc -l)
    fdupes -qdN -r "$1"
    AFTER=$(ls "$1" | wc -l)
    info "BEFORE: ${BEFORE} Files"
    info " AFTER: ${AFTER} Files"
}

function sortPathToDir
{
    if [[ "$EXT_FLAG" -eq 0 ]]; then
        for vid in $1.{png,PNG,jpg,JPG,jpeg,JPEG,eps,EPS,svg,SVG,pdf,PDF,ai}; do
            if [ -f "$vid" ] && [[ $vid != .* ]]; then
                VBN=$(basename "$vid")
                if [ -f "${XV}/${VBN}" ]; then
                    warn "Skipping ${vid}. Already Moved"
                else
                    # We have found a valid image file
                    info "Sorting ${VBN}"
                    cp "${vid}" "${XV}/${VBN}"
                    DFD=$((DFD + 1))
                fi
            fi
        done
    fi

    if [[ "$EXT_FLAG" -eq 1 ]]; then
        fontarray=("jpg,jpeg,png,JPG,JPEG,PNG" "ai,AI,eps,EPS,pdf,PDF" "svg,SVG")

        for i in "${fontarray[@]}"; do

            FIGFONT="${i}"
            echo -e "\nFONT: ${BRED}${FIGFONT}${NORMAL}"
            printFontBanner

        done

        for vid in $1.{png,PNG,jpg,JPG,jpeg,JPEG,eps,EPS,svg,SVG,pdf,PDF,ai}; do
            EXT=""
            if [ -f "$vid" ] && [[ $vid != .* ]]; then
                VBN=$(basename "$vid")
                if [ -f "${XV}/${EXT}/${VBN}" ]; then
                    warn "Skipping ${vid}. Already Moved"
                else
                    # We have found a valid image file
                    info "Sorting ${VBN}"
                    cp "${vid}" "${XV}/${VBN}"
                    DFD=$((DFD + 1))
                fi
            fi
        done
    fi
}

function sortImages
{
    mkdir -p "${XV}"

    DFD=0
    info "Merging all PNG, JPG, PDF, EPS, & SVG files into one folder."

    sortPathToDir "${IMGPATH}/*"
    sortPathToDir "${IMGPATH}/**/*"
    sortPathToDir "${IMGPATH}/**/**/*"
    sortPathToDir "${IMGPATH}/**/**/**/*"

    good "Found ${DFD} Images"

    if [[ "$DEDUPE_FLAG" -eq 1 ]]; then
        run_banner "Removing Duplicates..."
        removeDupes "$XV"
    fi

    if [[ "$PACK_FLAG" -eq 1 ]]; then
        run_banner "Compressing Images..."
        packItUp "$XV"
    fi

    good "Script Finished!"
}

## SHOW BANNER
banner

## Bash Argument Parsing Example
## EXAMPLE: ./new.sh -a -b test
## -----------------------------
PACK_FLAG=0
SORT_FLAG=0
DEDUPE_FLAG=0
EXT_FLAG=0
PARAMS=""
while (("$#")); do
    case "$1" in
        -p | --pack)
            PACK_FLAG=1
            run_banner "Compressing Images..."
            packItUp "$XV"
            shift
            ;;
        -d | --dedupe)
            DEDUPE_FLAG=1
            run_banner "Removing Duplicates..."
            removeDupes "$XV"
            shift
            ;;
        -e | --extensions)
            EXT_FLAG=1
            run_banner "Extension Sorting Enabled"
            shift
            ;;
        -l | --location)
            XV=$2
            run_banner "SAVING TO: ${XV}"
            shift
            ;;
        -s | --sort)
            SORT_FLAG=1
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                IMGPATH=$2
                shift 2
            else
                die "$1 is missing path option!" >&2
                exit 1
            fi
            run_banner "Sorting Images..."
            sortImages
            shift
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
    show_help
    die "No Options Passed!"
fi
