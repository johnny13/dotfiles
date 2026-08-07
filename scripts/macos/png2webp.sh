#!/bin/bash

# 1. Ensure cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "Error: 'cwebp' tool is missing."
    echo "Please install it via Homebrew: brew install webp"
    exit 1
fi

# 2. Get target directory (defaults to current directory if omitted)
TARGET_DIR="${1:-.}"

# Verify directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Scanning '$TARGET_DIR' for PNG files..."
echo "----------------------------------------"

# 3. Safely gather PNG files (handles spaces in filenames)
shopt -s nullglob caseglob
files=("$TARGET_DIR"/*.png "$TARGET_DIR"/*.PNG)

if [ ${#files[@]} -eq 0 ]; then
    echo "No PNG files found in '$TARGET_DIR'."
    exit 0
fi

converted_count=0

# 4. Process files
for file in "${files[@]}"; do
    # Strip extension to build output path
    base_path="${file%.*}"
    output_file="${base_path}.webp"
    
    echo "Converting: $(basename "$file") → $(basename "$output_file")"
    
    # Run cwebp (-q 80 sets 80% quality; change or add -lossless if preferred)
    if cwebp -q 80 "$file" -o "$output_file" &> /dev/null; then
        ((converted_count++))
    else
        echo "  [x] Failed to convert: $(basename "$file")"
    fi
done

echo "----------------------------------------"
echo "Done! Successfully converted $converted_count file(s)."