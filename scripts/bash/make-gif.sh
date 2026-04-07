#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./make_gif.sh /path/to/screenshots"
    exit 1
fi

INPUT_DIR=$(realpath "$1")
OUTPUT_NAME="cyberpunk_cinematic.gif"
WIDTH=1200
HOLD_TIME=2       # Seconds to show the image
FADE_TIME=0.5     # Seconds to fade to/from black

TEMP_DIR="/tmp/cyber_safe_$(date +%s)"
mkdir -p "$TEMP_DIR"

files=($(ls -1v "$INPUT_DIR"/*.png))
num_files=${#files[@]}

echo "🎬 Processing $num_files images via stream (RAM safe)..."

# 1. Create individual clips with fades
for ((i=0; i<num_files; i++)); do
    echo -n "█"
    # Create a clip that: Fades in (0.5s) -> Holds (2s) -> Fades out (0.5s)
    ffmpeg -loop 1 -i "${files[$i]}" -t $((HOLD_TIME + FADE_TIME*2)) \
    -vf "scale=$WIDTH:-1:force_original_aspect_ratio=decrease,pad=$WIDTH:$WIDTH*9/16:(ow-iw)/2:(oh-ih)/2,fade=t=in:st=0:d=$FADE_TIME,fade=t=out:st=$((HOLD_TIME+FADE_TIME)):d=$FADE_TIME" \
    -c:v libx264 -pix_fmt yuv420p -preset superfast "$TEMP_DIR/clip_$i.mp4" -y > /dev/null 2>&1
done

echo " ]"

# 2. Stitch them together
printf "file '%s'\n" "$TEMP_DIR"/*.mp4 > "$TEMP_DIR/list.txt"
ffmpeg -f concat -safe 0 -i "$TEMP_DIR/list.txt" -c copy "$TEMP_DIR/full_video.mp4" -y > /dev/null 2>&1

# 3. Convert to GIF using a palette (High Quality)
echo "🎨 Finalizing GIF..."
ffmpeg -i "$TEMP_DIR/full_video.mp4" -vf "fps=12,palettegen" -y "$TEMP_DIR/palette.png" > /dev/null 2>&1
ffmpeg -i "$TEMP_DIR/full_video.mp4" -i "$TEMP_DIR/palette.png" -lavfi "fps=12 [x]; [x][1:v] paletteuse" -y "$TEMP_DIR/raw.gif" > /dev/null 2>&1

# 4. Optimize file size (Crucial for Cyberpunk details)
if command -v gifsicle &> /dev/null; then
    echo "⚖️ Optimizing file size..."
    gifsicle -O3 --lossy=30 "$TEMP_DIR/raw.gif" -o "$OUTPUT_NAME"
else
    mv "$TEMP_DIR/raw.gif" "$OUTPUT_NAME"
fi

rm -rf "$TEMP_DIR"
echo "✨ Done! GIF saved as: $OUTPUT_NAME"