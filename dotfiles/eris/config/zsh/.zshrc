# source '/Users/eris/.local/share/dorothy/init.sh' # Dorothy
export DOTFILES="/Users/eris/Dotfiles"

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

PATH="/Users/eris/.composer/vendor/bin/:/Users/eris/.cargo/bin:${DOTFILES}/scripts/bash:${DOTFILES}/scripts/macos:/Users/eris/.bin:$PATH"

# PATH="/Users/eris/.cargo/bin:$PATH:/usr/local/lib/python3.12/site-packages:${PATH}"

export OCI_CLI_USER="ocid1.user.oc1..aaaaaaaa6sa4fjz7jg256y5v6eohch4ti3ssq4vrngud4hfidachxtijfwqa"

# NODE
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# RUBY
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.5
