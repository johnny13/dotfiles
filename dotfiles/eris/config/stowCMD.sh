#!/usr/bin/env bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config"

cd "$DOTFILES_DIR" || exit 1

# 1. Clean up macOS .DS_Store clutter
echo "🧹 Removing .DS_Store files..."
find "$DOTFILES_DIR" -name ".DS_Store" -type f -delete

# Helper function to restow a single package
stow_package() {
    local pkg="$1"
    # Ensure package exists and is a directory
    if [[ -d "$pkg" ]]; then
        echo "--> Restowing package: $pkg"
        stow --restow --target="$TARGET_DIR" "$pkg"
    else
        echo "❌ Error: Package directory '$pkg' not found in $DOTFILES_DIR"
        exit 1
    fi
}

# 2. Check for optional package argument
if [[ -n "$1" ]]; then
    # Single package mode (e.g., ./stowCMD micro)
    echo "======================================"
    echo " Stowing single package: $1"
    echo " Target location:       $TARGET_DIR"
    echo "======================================"
    echo ""
    stow_package "$1"
else
    # Batch mode: Stow every folder
    echo "======================================"
    echo " Stowing all packages from: $DOTFILES_DIR"
    echo " Target location:           $TARGET_DIR"
    echo "======================================"
    echo ""
    for dir in */; do
        pkg="${dir%/}"

        # Skip hidden directories (like .git)
        if [[ "$pkg" == .* ]]; then
            continue
        fi

        stow_package "$pkg"
    done
fi

echo ""
echo "✨ Complete!"

