#!/usr/bin/env bash

# /Users/fortune/Library/Group Containers/G69SCX94XU.duck/Library/Application Support/duck/Volumes/EVO Seedbox/downloads/24
FROM='/Users/fortune/Library/Group\ Containers/G69SCX94XU.duck/Library/Application\ Support/duck/Volumes/EVO\ Seedbox/downloads/rand'
TO="/Volumes/Vault/_seedbox"
MAX_AGE="60" # minutes

TMPFILE=$(mktemp)

echo $FROM
eval cd $FROM
echo "Getting file list.."
find * -type f -mmin -$MAX_AGE > $TMPFILE
echo $TMPFILE
# rclone -vv --files-from=$TMPFILE --no-traverse copy $FROM $TO
# rm $TMPFILE