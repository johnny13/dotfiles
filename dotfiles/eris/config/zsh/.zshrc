export DOTFILES="/Users/eris/Dotfiles"

export STARSHIP_CONFIG='/Users/eris/.config/starship.toml'

eval "$(starship init zsh)"

bindkey "[D" backward-word
bindkey "[C" forward-word

export EDITOR=micro
export VISUAL="/usr/local/bin/mate -w"

export NDI_SDK_DIR="/Library/NDI SDK for Apple"

eval $(ssh-agent)

source <(fzf --zsh)

# Check and source .alias file if it exists
[ -f "/Users/eris/.alias" ] && source "/Users/eris/.alias"

# Check and source .z-private file if it exists
[ -f "/Users/eris/.z-private" ] && source "/Users/eris/.z-private"

# Check and source .zsh-z.plugin.zsh file if it exists
[ -f "/Users/eris/.zsh-z.plugin.zsh" ] && source "/Users/eris/.zsh-z.plugin.zsh"

PATH="/Users/eris/Developer/depot_tools:/Users/eris/Library/Application Support/Herd/bin:$PATH"
PATH="/Users/eris/.composer/vendor/bin/:/Users/eris/.cargo/bin:${DOTFILES}/scripts/bash:${DOTFILES}/scripts/macos:/Users/eris/.bin:/Users/eris/.local/bin:/usr/local/sbin:/usr/local/bin:$PATH"

# NODE
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# RUBY
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.5

# Added by Antigravity
export PATH="/Users/eris/.antigravity/antigravity/bin:$PATH"

# Function to open Clean Recording Browser
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
# Added by Windsurf
export PATH="/Users/eris/.codeium/windsurf/bin:$PATH"

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

function getfont() {
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
export PATH="/usr/local/opt/ffmpeg-full/bin:$PATH"
