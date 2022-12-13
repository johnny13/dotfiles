#!/usr/local/bin/bash

## Figlet Font Examples
## --------------------
## Shows each figlet font installed on your system.

clear

figlist | awk '/fonts/ {f=1;next} /control/ {f=0} f {print}' | while read font; do
  echo "=== ${font} ==="
  figlet -f "${font}" -w 150 "${font}"
done | less

#exit
