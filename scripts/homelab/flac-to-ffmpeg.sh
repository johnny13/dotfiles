#!/bin/bash

for filename in "$@"; do
  output_file="${filename[@]/%flac/mp3}"
  ffmpeg -i "$filename" -ab 320k -map_metadata 0 -id3v2_version 3 "$output_file"
done