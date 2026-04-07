#!/bin/bash

# Load the ANSI library
source "/Users/eris/Dotfiles/scripts/_templates/bash-full/library/ansi" || { echo "ANSI library not found"; exit 1; }

# ANSI color variables (Using your tput setup)
RESET="$(tput sgr0)" 
NC="$(tput sgr0)" 
BOLD="$(tput bold)" 
UNDERLINE="$(tput smul)" 
NOUNDER="$(tput rmul)" 
BLINK="$(tput blink)" 
REVERSE="$(tput rev)" 
BLACK="$(tput setaf 0)" 
RED="$(tput setaf 1)" 
GREEN="$(tput setaf 2)" 
YELLOW="$(tput setaf 3)" 
BLUE="$(tput setaf 4)" 
PURPLE="$(tput setaf 5)" 
CYAN="$(tput setaf 6)" 
WHITE="$(tput setaf 7)" 
DIVIDER=$(ansi --bold --bg-blue --white "==========================================")

# Config for Renaming
# Excludes: 1, l, o, O, 0
CHARSET="abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ23456789"

show_help() {
    echo "${BLUE}"
    echo "Image Optimization & Management Utility v1.2"
    echo ""
    echo "${YELLOW}USAGE:${RESET}"
    echo "  ./imgmgmt.sh [directory] [options]"
    echo ""
    echo "${YELLOW}OPTIONS:${RESET}"
    echo "  -r, --rename    Rename batch to 'img_<hash>_01.ext' (Sequential numbering)"
    echo "  -h, --help      Show this help screen"
    echo ""
    echo "${YELLOW}EXAMPLES:${RESET}"
    echo "  ./imgmgmt.sh ./resources/images"
    echo "  ./imgmgmt.sh ./public/assets --rename"
    echo ""
    exit 0
}

# Generate a single hash for the entire session
generate_session_hash() {
    echo "$CHARSET" | sed 's/./&\n/g' | gshuf -n 4 | tr -d '\n'
}

resize_image() {
    local src=$1 dest=$2 size=$3 quality=$4
    convert "$src" -resize "${size}x${size}^" -gravity center -extent "${size}x${size}" -quality "$quality" "$dest"
}

# Argument Parsing
SEARCH_DIR=""
SHOULD_RENAME=false

if [[ $# -eq 0 ]]; then show_help; fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -r|--rename)
            SHOULD_RENAME=true
            shift
            ;;
        -*)
            echo "${RED}Unknown option: $1${RESET}"
            exit 1
            ;;
        *)
            if [[ -z "$SEARCH_DIR" ]]; then
                SEARCH_DIR="$1"
            fi
            shift
            ;;
    esac
done

# Validate directory
if [[ ! -d "$SEARCH_DIR" ]]; then
    echo "${RED}Error: Directory '$SEARCH_DIR' not found.${RESET}"
    exit 1
fi

# 1. Generate the session hash ONCE before the loop starts
SESSION_HASH=$(generate_session_hash)

# Thumbs directory
THUMBS_DIR="./public/images/thumbs"
mkdir -p "$THUMBS_DIR"

# Banner
echo "${BLUE}"
cat << "EOF"
        |_|   o┏┏┓┏━┓┏┏┓┏━┓┏┏┓┏┓┓   |_|
        |_|   ┃┃┃┃┃ ┳┃┃┃┃ ┳┃┃┃ ┃    |_|
        |_|   ┇┛ ┇┇━┛┛ ┇┇━┛┛ ┇ ┇    |_|
        |_|                         |_|
        | |        v 1.2.0          | |
EOF
echo "${RESET}"

# Count total images
TOTAL_IMAGES=$(find "$SEARCH_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)
CURRENT=0

echo "${GREEN}Starting batch [${SESSION_HASH}] for $TOTAL_IMAGES images...${RESET}"

# Process images
find "$SEARCH_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | while read -d $'\0' -r file; do
    ((CURRENT++))
    PERCENT=$(echo "scale=2; ($CURRENT * 100) / $TOTAL_IMAGES" | bc)
    
    # Format the number with leading zeros (01, 02, etc.)
    NUM=$(printf "%02d" $CURRENT)
    
    echo ""
    echo "$DIVIDER"
    echo "${YELLOW}Progress: ${PERCENT}% [${CURRENT}/${TOTAL_IMAGES}]${RESET}"
    echo "${GREEN}Processing: $file${RESET}"

    # 1. Handle Extension Normalization (.jpeg -> .jpg)
    if [[ "$file" =~ \.jpeg$ ]]; then
        new_ext_file="${file%.jpeg}.jpg"
        mv -n "$file" "$new_ext_file"
        file="$new_ext_file"
    fi

    # 2. Handle Optional Renaming (img_<session_hash>_<num>.ext)
    if [ "$SHOULD_RENAME" = true ]; then
        DIR=$(dirname "$file")
        EXT="${file##*.}"
        NEW_NAME="img_${SESSION_HASH}_${NUM}.${EXT}"
        NEW_PATH="$DIR/$NEW_NAME"
        
        # Don't rename if the name already matches our pattern to avoid double-hashing
        if [[ ! $(basename "$file") =~ ^img_[${CHARSET}]{4}_[0-9]{2,}\. ]]; then
            mv -n "$file" "$NEW_PATH"
            file="$NEW_PATH"
            echo "${BLUE}Renamed to: $(basename "$file")${RESET}"
        fi
    fi

    # 3. Optimize Original
    if [[ "$file" =~ \.jpg$ ]]; then
        filesize=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
        if [ "$filesize" -gt 102400 ]; then
            convert "$file" -strip -interlace Plane -quality 75 "$file"
        else
            convert "$file" -strip -interlace Plane -quality 60 "$file"
        fi

        # 4. Generate Thumbnails
        dimensions=$(identify -format "%w %h" "$file")
        read width height <<< "$dimensions"
        
        if [ "$width" -gt 200 ] || [ "$height" -gt 200 ]; then
            BASE_NAME=$(basename "$file")
            
            # Create 200x200
            thumb_200="${THUMBS_DIR}/${BASE_NAME%.*}-200.jpg"
            if [ ! -f "$thumb_200" ]; then
                resize_image "$file" "$thumb_200" 200 60
                echo "${CYAN}Created 200x200 thumb${RESET}"
            fi

            # Create 500x500
            thumb_500="${THUMBS_DIR}/${BASE_NAME%.*}-500.jpg"
            if [ ! -f "$thumb_500" ]; then
                resize_image "$file" "$thumb_500" 500 80
                echo "${CYAN}Created 500x500 thumb${RESET}"
            fi
        fi

    elif [[ "$file" =~ \.png$ ]]; then
        pngquant --ext .png --force --quality 65-80 "$file"
        echo "${BLUE}Optimized PNG with pngquant${RESET}"
    fi
done

echo ""
echo "$DIVIDER"
echo "${GREEN}Complete! Processed $TOTAL_IMAGES images with batch ID: $SESSION_HASH${RESET}"
echo "$DIVIDER"