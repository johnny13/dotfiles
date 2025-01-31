
# Convert .flac to .mp3 (lossless)
for f in *.flac; do ffmpeg -i "$f" -aq 1 "${f%flac}mp3"; done

# Convert .flac to .mp3, compress to ~ 120k
for f in *.flac; do ffmpeg -i "$f" -aq 5 "${f%flac}mp3"; done

# Convert .flac to mp3, compress to ~ 128k
for f in *.flac; do ffmpeg -i "$f" -b:a 128k "${f%flac}mp3"; done

# Convert .flac to mp3, compress to variable 190k
for f in *.flac; do ffmpeg -i "$f" -aq 2 "${f%flac}mp3"; done

# Compress .mp3 files with lame to constant 128k
for i in *.mp3; do lame --preset 128 "$i" "${i}.mp3"; done

# Compress .mp3 to variable 190k (constant quality)
for i in *.mp3; do lame -V2 "$i"; done

# Compress .mp3 to variable 190k bitrate and replace files
for i in *.mp3; do lame -V2 "$i" tmp && mv tmp "$i"; done