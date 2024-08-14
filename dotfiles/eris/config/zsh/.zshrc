# source '/Users/eris/.local/share/dorothy/init.sh' # Dorothy

export STARSHIP_CONFIG='/Users/eris/.config/starship.toml'

eval "$(starship init zsh)"

bindkey "[D" backward-word
bindkey "[C" forward-word

export EDITOR=micro
export VISUAL="/usr/local/bin/mate -w"

eval $(ssh-agent)

source "/Users/eris/.alias"

source <(fzf --zsh)

PATH="/Users/eris/.cargo/bin:$PATH"
