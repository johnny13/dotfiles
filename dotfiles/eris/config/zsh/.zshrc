# source '/Users/eris/.local/share/dorothy/init.sh' # Dorothy

export STARSHIP_CONFIG='/Users/eris/.config/starship.toml'

eval "$(starship init zsh)"

bindkey "[D" backward-word
bindkey "[C" forward-word

export EDITOR=micro
export VISUAL="/usr/local/bin/mate -w"

eval $(ssh-agent)

source "/Users/eris/.alias"

source "/Users/eris/.zsh-z.plugin.zsh"

source <(fzf --zsh)

PATH="/Users/eris/.cargo/bin:$PATH"

export OCI_CLI_USER="ocid1.user.oc1..aaaaaaaa6sa4fjz7jg256y5v6eohch4ti3ssq4vrngud4hfidachxtijfwqa"
