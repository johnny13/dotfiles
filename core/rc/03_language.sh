# ------------------------

###
## LANGUAGES
###
export GOPATH="$HOME/go_projects"
export GOBIN="$GOPATH/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export NVM_COLORS='cmgRY'

#nvm use default
#"$NVM_DIR/nvm.sh" use 14.15.4 --silent

#eval "$(grunt --completion=bash)"

hs()
{
    (cd ~/Homestead && vagrant "$*")
}

alias vagrant-global='vagrant global-status'
alias vagrant-repo='$(vagrant reload --povision)'

alias foreman='colourify foreman'

source_if_exists "$HOME/.cargo/env"

export PYTHONPATH="${PYTHONPATH}:/home/lucky/.local/lib/python3.8"