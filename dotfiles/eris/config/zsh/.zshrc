export DOTFILES="/Users/eris/Dotfiles"
export STARSHIP_CONFIG='/Users/eris/.config/starship.toml'

eval "$(starship init zsh)"

bindkey "[D" backward-word
bindkey "[C" forward-word

export EDITOR=micro
export VISUAL="/usr/local/bin/mate -w"
export BAT_THEME="tokyonight_night"

export NDI_SDK_DIR="/Library/NDI SDK for Apple"

export HOMEBREW_NO_REQUIRE_TAP_TRUST=1

source "/Users/eris/Dotfiles/dotfiles/eris/functions.sh"

eval $(ssh-agent)

source <(fzf --zsh)

# Check and source .alias file if it exists
[ -f "/Users/eris/.alias" ] && source "/Users/eris/.alias"

# Check and source .z-private file if it exists
[ -f "/Users/eris/.z-private" ] && source "/Users/eris/.z-private"

# Check and source .zsh-z.plugin.zsh file if it exists
[ -f "/Users/eris/.zsh-z.plugin.zsh" ] && source "/Users/eris/.zsh-z.plugin.zsh"

PATH="$PATH:/Users/eris/.composer/vendor/bin/:/Users/eris/.cargo/bin:${DOTFILES}/scripts/bash:${DOTFILES}/scripts/macos:/Users/eris/.bin:/Users/eris/.local/bin:/usr/local/sbin:/usr/local/bin"
# Added by Antigravity
PATH="/Users/eris/.antigravity/antigravity/bin:$PATH"
PATH="/Users/eris/.codeium/windsurf/bin:$PATH"

# NODE
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# RUBY
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.5

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export PATH="/usr/local/opt/ffmpeg-full/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/eris/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

autoload -U +X bashcompinit && bashcompinit

# Minio 
complete -o nospace -C /usr/local/bin/mc mc
