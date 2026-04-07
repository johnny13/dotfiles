#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/images"
    exit 1
fi

INPUT_DIR=$(realpath "$1")
OUTPUT_GIF="cyberpunk_cinematic.gif"
WIDTH=1000        # resize width
HOLD_FRAMES=30    # frames to hold each image before fading
FADE_FRAMES=15    # frames for crossfade
FPS=15            # GIF framerate
TEMP_DIR="/tmp/cyber_morph_$(date +%s)"

mkdir -p "$TEMP_DIR"

# Get sorted list of PNGs
FILES=($(ls -1v "$INPUT_DIR"/*.png))
NUM_FILES=${#FILES[@]}

echo "Found $NUM_FILES images. Generating morph frames..."

FRAME_COUNT=0

for ((i=0; i<NUM_FILES; i++)); do
    SRC="${FILES[$i]}"

    # Resize image once to temp dir
    RESIZED="$TEMP_DIR/resized_$(basename "$SRC")"
    convert "$SRC" -resize ${WIDTH} -strip -colorspace sRGB "$RESIZED"

    # Hold the image for HOLD_FRAMES
    for ((h=0; h<HOLD_FRAMES; h++)); do
        FILENAME=$(printf "$TEMP_DIR/frame_%04d.png" $FRAME_COUNT)
        cp "$RESIZED" "$FILENAME"
        ((FRAME_COUNT++))
    done

    # If not last image, generate fade/morph to next
    if [ $i -lt $((NUM_FILES-1)) ]; then
        NEXT="${FILES[$((i+1))]}"
        RESIZED_NEXT="$TEMP_DIR/resized_$(basename "$NEXT")"
        convert "$NEXT" -resize ${WIDTH} -strip -colorspace sRGB "$RESIZED_NEXT"

        # Morph frames
        convert "$RESIZED" "$RESIZED_NEXT" -morph $FADE_FRAMES \
            $(for ((f=0; f<FADE_FRAMES; f++)); do
                FILENAME=$(printf "$TEMP_DIR/frame_%04d.png" $FRAME_COUNT)
                echo "$FILENAME"
                ((FRAME_COUNT++))
            done)
    fi
done

echo "Morph frames generated: $FRAME_COUNT"

# Now combine all frames into a GIF using ffmpeg
echo "Encoding GIF with ffmpeg..."
ffmpeg -y -framerate $FPS -i "$TEMP_DIR/frame_%04d.png" -vf "palettegen" "$TEMP_DIR/palette.png"
ffmpeg -y -framerate $FPS -i "$TEMP_DIR/frame_%04d.png" -i "$TEMP_DIR/palette.png" \
    -lavfi "paletteuse" "$OUTPUT_GIF"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✨ Done! GIF created: $OUTPUT_GIF"