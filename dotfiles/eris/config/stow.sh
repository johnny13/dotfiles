#!/usr/bin/env bash

# Resolve home directory safely
USER_HOME="${HOME:-/Users/$(whoami)}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${USER_HOME}/.config"

cd "$DOTFILES_DIR" || exit 1

# 1. Clean up macOS .DS_Store clutter
echo "🧹 Removing .DS_Store files..."
find "$DOTFILES_DIR" -name ".DS_Store" -type f -delete

# Helper function to stow a single package
stow_package() {
    local pkg="$1"

    if [[ ! -d "$pkg" ]]; then
        echo "❌ Error: Package directory '$pkg' not found in $DOTFILES_DIR"
        exit 1
    fi

    # Set appropriate target directory per package
    if [[ "$pkg" == "starship" ]]; then
        # Starship config belongs directly in ~/.config/starship.toml
        local target_path="$CONFIG_DIR"
    else
        # App configs belong inside ~/.config/<package>/
        local target_path="${CONFIG_DIR}/${pkg}"
    fi

    # Ensure target directory exists
    mkdir -p "$target_path" || { echo "❌ Failed to create directory: $target_path"; exit 1; }

    echo "--> Restowing '$pkg' into: $target_path"
    if stow --restow --target="$target_path" "$pkg"; then
        echo "   ✅ Successfully stowed $pkg"
    else
        echo "   ❌ Stow failed for $pkg"
        exit 1
    fi
}

# 2. Check for optional package argument
if [[ -n "$1" ]]; then
    # Single package mode (e.g., ./stowCMD.sh borders)
    echo "======================================"
    echo " Stowing single package: $1"
    echo "======================================"
    echo ""
    stow_package "$1"
else
    # Batch mode: Stow every folder
    echo "======================================"
    echo " Stowing all packages into $CONFIG_DIR"
    echo "======================================"
    echo ""
    for dir in */; do
        pkg="${dir%/}"

        # Skip hidden directories
        if [[ "$pkg" == .* ]]; then
            continue
        fi

        stow_package "$pkg"
    done
fi

echo ""
echo "✨ Complete!"
