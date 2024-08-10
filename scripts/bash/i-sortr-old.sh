#!/usr/local/bin/bash
#/
#/ Allows you to move images into folders based on file size and/or extension.
#/ Additionally cleans up file extension capitalization errors, and removes
#/ duplicate files. Will also zip the result for easy transfer.
#/
#/ EXAMPLE: ./i-sortr.sh -s ./new-cat-files -t ~/Pictures/category
#/
#/ OPTIONS:
#/    -d|--dedupe)
#/       Remove any duplicates (requires 'fdupes' package)
#/    -e|--extensions)
#/       Sort by Raster / Vector categories on the end result
#/    -i|--icons)
#/       Filter out icons from end result
#/    -m|--merge <DIR>)
#/       Rsync Merge into given directory
#/    -p|--pack)
#/       Package the end result into a .zip archive saved to target directory
#/    -s|--sort <DIR>)
#/       Sort the images in given Directory
#/
#/ REQUIRED:
#/    -t|--target <DIR>)
#/       Where to put the sorted images. If not given ~/Pictures is used
#/
#/ HELP:
#/    -h|-?|--help)
#/       show this help and exit
#/

SCRIPT=$(realpath -s "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

## CUSTOMIZE THIS PART
TARGET_DIR="~/Pictures"
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
    cat <<EOF
[0;1;33;93m██[0;1;32;92m╗[0m      [0;1;35;95m█[0;1;31;91m██[0;1;33;93m██[0;1;32;92m██[0;1;36;96m╗[0m [0;1;34;94m██[0;1;35;95m██[0;1;31;91m██[0;1;33;93m╗[0m [0;1;32;92m██[0;1;36;96m██[0;1;34;94m██[0;1;35;95m╗[0m [0;1;31;91m██[0;1;33;93m██[0;1;32;92m██[0;1;36;96m██[0;1;34;94m╗█[0;1;35;95m██[0;1;31;91m██[0;1;33;93m█╗[0m
[0;1;32;92m██[0;1;36;96m║[0m      [0;1;31;91m█[0;1;33;93m█╔[0;1;32;92m╝╝[0;1;36;96m╝╝[0;1;34;94m╝█[0;1;35;95m█╔[0;1;31;91m╝╝[0;1;33;93m╝█[0;1;32;92m█╗[0;1;36;96m██[0;1;34;94m╔╝[0;1;35;95m╝█[0;1;31;91m█╗[0;1;33;93m╚╝[0;1;32;92m╝█[0;1;36;96m█╔[0;1;34;94m╝╝[0;1;35;95m╝█[0;1;31;91m█╔[0;1;33;93m╝╝[0;1;32;92m██[0;1;36;96m╗[0m
[0;1;36;96m██[0;1;34;94m║█[0;1;35;95m██[0;1;31;91m██[0;1;33;93m╗█[0;1;32;92m██[0;1;36;96m██[0;1;34;94m██[0;1;35;95m╗█[0;1;31;91m█║[0m   [0;1;32;92m█[0;1;36;96m█║[0;1;34;94m██[0;1;35;95m██[0;1;31;91m██[0;1;33;93m╔╝[0m   [0;1;36;96m█[0;1;34;94m█║[0m   [0;1;31;91m█[0;1;33;93m██[0;1;32;92m██[0;1;36;96m█╔[0;1;34;94m╝[0m
[0;1;34;94m██[0;1;35;95m║╚[0;1;31;91m╝╝[0;1;33;93m╝╝[0;1;32;92m╝╚[0;1;36;96m╝╝[0;1;34;94m╝╝[0;1;35;95m██[0;1;31;91m║█[0;1;33;93m█║[0m   [0;1;36;96m█[0;1;34;94m█║[0;1;35;95m██[0;1;31;91m╔╝[0;1;33;93m╝█[0;1;32;92m█╗[0m   [0;1;34;94m█[0;1;35;95m█║[0m   [0;1;33;93m█[0;1;32;92m█╔[0;1;36;96m╝╝[0;1;34;94m██[0;1;35;95m╗[0m
[0;1;35;95m██[0;1;31;91m║[0m      [0;1;36;96m█[0;1;34;94m██[0;1;35;95m██[0;1;31;91m██[0;1;33;93m║╚[0;1;32;92m██[0;1;36;96m██[0;1;34;94m██[0;1;35;95m╔╝[0;1;31;91m██[0;1;33;93m║[0m  [0;1;32;92m█[0;1;36;96m█║[0m   [0;1;35;95m█[0;1;31;91m█║[0m   [0;1;32;92m█[0;1;36;96m█║[0m  [0;1;35;95m██[0;1;31;91m║[0m
[0;1;31;91m╚╝[0;1;33;93m╝[0m      [0;1;34;94m╚[0;1;35;95m╝╝[0;1;31;91m╝╝[0;1;33;93m╝╝[0;1;32;92m╝[0m [0;1;36;96m╚╝[0;1;34;94m╝╝[0;1;35;95m╝╝[0;1;31;91m╝[0m [0;1;33;93m╚╝[0;1;32;92m╝[0m  [0;1;36;96m╚[0;1;34;94m╝╝[0m   [0;1;31;91m╚[0;1;33;93m╝╝[0m   [0;1;36;96m╚[0;1;34;94m╝╝[0m  [0;1;31;91m╚╝[0;1;33;93m╝[0m
EOF
    echo " "
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

function status
{
    echo -e "${BPUR}[STAT]${NORMAL} $1"
}

function show_help
{
    grep '^#/' "${SCRIPT}" | cut -c4- ||
        die "Failed to display usage information"
}

function _hashes
{
    HC=50
    CS="x"
    echo -ne "${BWHT}${B_CYN}"
    printf %"$HC"s | tr " " "$CS"
    echo -ne "${NORMAL}\n\n"
}

function run_banner
{
    echo ""
    echo -e "       ${BYLW}>>>  ${BCYN}$1  ${BYLW}<<<  ${NORMAL}"
    echo ""
}

########
######## FUNCTIONS
########

function packItUp
{
    info "Compressing Files in: $1"
    tmpfile=$(mktemp /tmp/SortedImages.zip)
    # zip -r "${ZIP}/images.zip" "$1"
    zip -r "$tmpfile" "$1"
    good "Archive Created!"
    mv "$tmpfile" "${TARGET_DIR}"
    #rm "$tmpfile"
    #ls -l "$1" | grep .zip
    mfs=$(du --apparent-size --block-size=1  "${TARGET_DIR}/SortedImages.zip" | awk '{ print $1}')
    good "Zip Archive Size: ${mfs}"
}

function removeDupes
{
    if ! command -v fdupes &>/dev/null; then
        die "Install fdupes command to remove duplicate files"
    else
        info "Searching Files in: $1"
        BEFORE=$(ls "$1" | wc -l)
        fdupes -qdN -r "$1"
        AFTER=$(ls "$1" | wc -l)
        status "BEFORE: ${BEFORE} Files"
        status " AFTER: ${AFTER} Files"
    fi
}

function renameFile
{
    FILE=$1
    randomString=$(openssl rand -base64 6)
    FileName=$(basename -- "$FILE")
    Extension="${FileName##*.}"
    FName="${FileName%.*}"
    local newName="${FName}_${randomString}.${Extension}"
}

function imgLogic
{
    imgFile=$1
    saveDir=$2

    if [ -f "$imgFile" ] && [[ $imgFile != .* ]]; then

        ImgBaseName=$(basename "$imgFile")

        if [ -f "${TARGET_DIR}/${ImgBaseName}" ]; then
            ## Check Filesize
            filesize_one=$(du -b "${TARGET_DIR}/${ImgBaseName}" | cut -f1)
            filesize_two=$(du -b "$imgFile" | cut -f1)

            if [ "$filesize_one" -eq "$filesize_two" ]; then
                warn "Skipping ${imgFile}. Already Moved"
            else
                info "Renaming ${imgFile} to avoid conflict"

                # randomString=$(openssl rand -base64 6)
                # imgFileName=$(basename -- "$imgFile")
                # imgExtension="${imgFileName##*.}"
                # imgName="${imgFileName%.*}"
                # newName="${imgName}_${randomString}.${imgExtension}"
                newName=$(renameFile "$imgFile")
                mv "${imgFile}" "${saveDir}/${newName}"
                DFD=$((DFD + 1))
            fi
        else
            # We have found a valid image file
            info "Sorting ${ImgBaseName}"
            mv "${imgFile}" "${saveDir}/${ImgBaseName}"
            DFD=$((DFD + 1))
        fi
    fi
}

function sortPathToDir
{
    ## Sort all Images
    if [[ "$EXT_FLAG" -eq 0 ]]; then
        for img in $1.{png,jpg,jpeg,eps,svg,ai}; do
            imgLogic $img "${TARGET_DIR}"
        done
    else
        ## Sort Images into Raster / Vector Subfolders
        for img in $1.{jpg,jpeg,png}; do
            imgLogic $img "${TARGET_DIR}/RASTERS"
        done

        for img in $1.{ai,eps,svg}; do
            imgLogic $img "${TARGET_DIR}/VECTORS"
        done
    fi

    ## Clean Out Any Bullshit Files
    for badFile in $1.{txt,pdf,doc}; do
        info "Removing Garbage File: ${badFile}"
        rm "$badFile"
    done
}

function mergeLibraries
{
    info "Rsyncing Directories"

    RTarget="$TARGET_DIR"

    rsync -abvuP "$RTarget" "$RDest"

    good "Finished Syncing!"
}

function filterIcons
{
    # Run Through Target Dir and move icons into subfolder
    info "Sorting Icons into Subfolder"

    filterCount=0

    # Linux Only
    # filesize=$(stat -c%s "$FILE")

    # MacOS
    # filesize=$(stat -f%z "$FILE")

    # POSIX
    #filesize=$(du -b "$FILE" | cut -f1)

    mkdir -p "${TARGET_DIR}/ICONS"
    mkdir -p "${TARGET_DIR}/ICONS_PNG"

    for FILE in $TARGET_DIR/*.{svg,eps}; do
        filesize=$(du -b "$FILE" | cut -f1)
        if [ "$filesize" -lt 80000 ]; then
            info "Moving Icon: $FILE"
            mv "$FILE" "${TARGET_DIR}/ICONS"
            filterCount=$((filterCount + 1))
        fi
    done

    for FILE in $TARGET_DIR/*.png; do
        filesize=$(du -b "$FILE" | cut -f1)
        if [ "$filesize" -lt 100000 ]; then
            info "Moving PNG Icon: $FILE"
            mv "$FILE" "${TARGET_DIR}/ICONS_PNG"
            filterCount=$((filterCount + 1))
        fi
    done

    good "Sorted ${filterCount} Icon Files"
}

function sortImages
{
    mkdir -p "${TARGET_DIR}"

    ## Cleanup Filenames first
    if ! command -v rename &>/dev/null; then
        die "Install rename command to correct capitalized extension errors"
    else
        info "lowercasing extensions SVG to svg etc..."
        rename -n 's/\.([^.]+)$/.\L$1/' *
    fi

    info "removing whitespace from all filenames"

    find "$IMGPATH" -depth -name '* *' |
        while IFS= read -r f; do mv -i "$f" "$(dirname "$f")/$(basename "$f" | tr ' ' _)"; done

    good "Preliminary Work Completed. Processing Starting!"

    DFD=0
    info "Merging all |png, jpg, svg, ai| files"

    sortPathToDir "${IMGPATH}/*"
    sortPathToDir "${IMGPATH}/**/*"
    sortPathToDir "${IMGPATH}/**/**/*"
    sortPathToDir "${IMGPATH}/**/**/**/*"

    good "Processed ${DFD} Images"

    info "Cleaning Empty Directories"
    find "${IMGPATH}/" -empty -type d -delete
}

function imageSortMain
{
    run_banner "Image Manager Activated"

    if [[ "$SORT_FLAG" -eq 1 ]]; then
        info "Starting Image Sort"
        sortImages
    fi

    if [[ "$DEDUPE_FLAG" -eq 1 ]]; then
        info "Starting Deduplication"
        removeDupes "$TARGET_DIR"
    fi

    if [[ "$ICON_FLAG" -eq 1 ]]; then
        info "Starting Icon Filtering"
        filterIcons
    fi

    if [[ "$PACK_FLAG" -eq 1 ]]; then
        info "Starting Image Compression"
        packItUp "$TARGET_DIR"
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
ICON_FLAG=0
PARAMS=""
while (("$#")); do
    case "$1" in
        -p | --pack)
            PACK_FLAG=1
            status "Compression Set"
            #packItUp "$TARGET_DIR"
            shift
            ;;
        -d | --dedupe)
            DEDUPE_FLAG=1
            status "Deduplication Set"
            #removeDupes "$TARGET_DIR"
            shift
            ;;
        -e | --extensions)
            EXT_FLAG=1
            status "Extension Sort Set"
            shift
            ;;
        -i | --icons)
            ICON_FLAG=1
            status "Icon Filter Set"
            shift
            ;;
        -t | --target)
            TARGET_DIR=$2
            # if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            #     TARGET_DIR=$2
            #     shift 2
            # else
            #     die "$1 is missing path option!" >&2
            # fi
            status "Saving to: ${TARGET_DIR}"
            shift
            ;;
        -s | --sort)
            SORT_FLAG=1
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                IMGPATH=$2
                shift 2
            else
                die "$1 is missing path option!" >&2
            fi
            status "Sorting: ${IMGPATH}"
            #sortImages
            shift
            ;;
        -m | --merge)
            RDest=$2
            status "Merging Results into ${RDest}"
            shift
            ;;
        -h | -\? | --help) # help
            show_help
            exit
            ;;
        -* | --*=) # unsupported flags
            die "Unsupported flag $1" >&2
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [ $ICON_FLAG -eq 0 ] && [ $DEDUPE_FLAG -eq 0 ] && [ $SORT_FLAG -eq 0 ] && [ $PACK_FLAG -eq 0 ]; then
    #show_help
    die "No Options Passed!"
else
    imageSortMain
fi
