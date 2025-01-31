#!/bin/bash
set -x

## USAGE: extract_flac2mp3.sh "path/to/dir"
## EXAMPLE: extract_flac2mp3.sh "FLAC_dir/Rush"
## DESCRIPTION: This script will search a directory for archives to extract,
## Then search for FLAC files to convert to v0 mp3
## Designed for use on OSX / macOS
## Requires pz7ip, and ffmpeg to be installed using Homebrew with these commands
## $ brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265
## $ brew update && brew upgrade ffmpeg
## $ brew install p7zip

# ~~~~~ SETTINGS ~~~~~ #
# file with passwords to try, one per line
password_file="passwords.txt"
divder="---------------------------------"


# ~~~~~ CUSTOM FUNCTIONS ~~~~~ #
find_archives () {
    local input_dir="$1"
    local password_file="$2"
    printf "\n%s\nSearching for archive files in directory:\n%s\n\n" "$divder" "$input_dir"
    find "${input_dir}/" \( -name '*.zip' -o -name '*.rar' -o -name '*.7z' \) -print0 | while read -d $'\0' read item; do
        cat "$password_file" | while read password; do
            if [ ! -z "$password" ]; then
                extract_archive "$item" "$password"
            fi
        done
    done

}

extract_archive () {
    local item="$1"
    local password="$2"
    local outdir="$(dirname "${item}")"
    printf "\nAttempting to extract file:\n%s\n\nUsing password:\n%s\n\nTo location:\n%s\n\n" "$item" "$password" "$outdir"
    7z x "$item" -p${password} -y -o"${outdir}"
}

find_flac () {
    local input_dir="$1"
    printf "\n%s\nSearching for FLAC files in directory:\n%s\n\n" "$divder" "$input_dir"
    find "${input_dir}/" -name "*.flac" -print0 | while read -d $'\0' item; do
        (
        output="${item%%.flac}.mp3"
        printf "\n%s\n" "$divder"
        printf "\nINPUT FLAC:\n%s\n\n" "$item"
        printf "\nOUTPUT MP3:\n%s\n\n" "$output"
        ffmpeg -y -i "$item" -aq 0 "$output" < /dev/null
        )
    done
}
# ~~~~~ CHECK SCRIPT ARGS ~~~~~ #
if (($# != 1)); then
  grep '^##' $0
  exit
fi

# ~~~~~ GET SCRIPT ARGS ~~~~~ #
input_dir="$1"

# ~~~~~ EXTRACT ARCHIVES ~~~~~ #
find_archives "$input_dir" "$password_file"

# ~~~~~ CONVERT FLAC ~~~~~ #
find_flac "$input_dir"