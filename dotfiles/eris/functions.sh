cleanbrowser() {
    # 1. Kill any existing Chromium instances
    pkill -f Chromium
    
    # 2. Wait a moment
    sleep 1

    # 3. Launch with quotes around the wildcard
    /Applications/Chromium.app/Contents/MacOS/Chromium \
    --app="data:text/html,<html><body style='background:black;'></body></html>" \
    --user-data-dir="/tmp/chromium-recording-profile" \
    --remote-debugging-port=9222 \
    --remote-allow-origins='*' \
    --window-size=1920,1080 \
    --no-first-run \
    --no-default-browser-check \
    "$@" &
}

getfont() {
    # 1. Check if fzf is actually installed
    if ! command -v fzf &> /dev/null; then
        echo "❌ fzf is not installed. Install it via brew: 'brew install fzf'"
        return 1
    fi

    local query="$1"
    local search_paths=("$HOME/Library/Fonts" "/Library/Fonts" "/System/Library/Fonts")

    # 2. Find fonts and pipe them into fzf
    #    - We search for .ttf, .otf, and .ttc
    #    - We pre-filter with your query if you provided one, otherwise list all
    #    - fzf options:
    #      --height: takes up 40% of screen
    #      --layout=reverse: list grows downwards
    #      --preview: shows file size/date for the selected file
    local selected_font
    selected_font=$(find "${search_paths[@]}" -type f \( -iname "*${query}*.ttf" -o -iname "*${query}*.otf" -o -iname "*${query}*.ttc" \) 2>/dev/null | \
        fzf --height=40% --layout=reverse --prompt="Select Font > " --preview="ls -lh {}")

    # 3. Copy if a selection was made
    if [[ -n "$selected_font" ]]; then
        cp "$selected_font" .
        echo "✅ Copied: $(basename "$selected_font")"
    fi
}