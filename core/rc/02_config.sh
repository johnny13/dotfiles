# ------------------------

###
## HISTORY
###
export HISTFILESIZE=20000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export HISTIGNORE='pwd:jobs:ll:ls:l:fg:history:clear:exit:exa:rm:cp:mkdir'
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HSTR_CONFIG=favorites-view,hicolor,prompt-bottom
alias hh=hstr                    # hh to be alias for hstr

export VISUAL=micro
export EDITOR="$VISUAL"
export PAGER=less
export READER="micro"
export NNN_USE_EDITOR=1
export BROWSER=lynx
export COLORTERM="truecolor"
export MICRO_TRUECOLOR=1
export XDG_CONF="$HOME"

if [ -z "${LANG}" ]; then
    export LANG="en_US.UTF-8"
fi

if [ -z "${LANGUAGE}" ]; then
    export LANGUAGE="en_US.UTF-8"
fi

export CYLONDEST="$HOME/.cylondeb"
export TTRV_EDITOR="/snap/bin/micro"
export TTRV_BROWSER="/usr/bin/google-chrome"
export TTRV_URLVIEWER="/home/lucky/.local/bin/urlscan"
export IMGUR_CLIENT_ID="70c664b4a78f42f"
export LC_ALL=C

export XDG_DATA_HOME='/home/lucky'
export YTFZF_THUMB_DISP_METHOD="chafa"

# TODO DECIDE IF USING DOTBARE OR NOT
export DOTBARE_DIFF_PAGER="delta --diff-so-fancy --line-numbers"
export DOTBARE_PREVIEW="bat -n {}"
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:65%"
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
export DOTBARE_TREE="$HOME"
export DOTBARE_DIR="$HOME/.cfg"

shopt -s checkwinsize           # Update window size after every command
shopt -s autocd                 # Prepend cd to directory names automatically
shopt -s dirspell               # Correct spelling errors during tab-completion
shopt -s cdspell                # Correct spelling errors in arguments supplied to cd
shopt -s nocaseglob             # Case-insensitive globbing (used in pathname expansion)
shopt -s globstar 2>/dev/null   # Recursive globbing (enables ** to recurse all directories)
shopt -s histappend             # append to the history file, don't overwrite it
shopt -s histreedit             # Add failed commands to the bash history
shopt -s histverify             # Edit a recalled history line before executing
shopt -s cmdhist                # Save multi-line commands in history as single line
shopt -s dotglob                # Include dotfiles in pathname expansion
shopt -s expand_aliases         # Expand aliases
shopt -s extglob                # Enable extended pattern-matching features

set -o noclobber

bind "set completion-ignore-case on"     # Perform file completion in a case insensitive fashion
bind "set completion-map-case on"        # Treat hyphens and underscores as the same
bind "set show-all-if-ambiguous on"      # Display matches for ambiguous patterns at first tab press
bind "set mark-symlinked-directories on" # Add trailing slash when autocompleting symlinks to directories
bind Space:magic-space                   # typing !!<space> will replace the !! with your last command

# if ! shopt -oq posix; then
#     source_if_exists /usr/share/bash-completion/bash_completion
#     source_if_exists /etc/bash_completion
# fi

if [ -x /usr/bin/dircolors ]; then
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
else
    # @TODO Make this use the logfile to limit annoyances
    echo "[INFO] You do not have dircolors setup. You should do that! For BASH shells do this:"
    echo -e "\t  sudo apt-get install coreutils"
    echo -e "\t  /usr/bin/dircolor -b >> ~/.bashrc"
fi

if _has "exa"; then
    alias ls='exa -lbhm@ --color-scale --group-directories-first'
    alias lsmod='exa -lbhm@ --color-scale --group-directories-first --sort=modified'
    alias lt='exa --sort=modified -T -L 2 --group-directories-first'
    alias lg='exa --color-scale -g'
    alias ll='/bin/ls --color=auto -alF'
fi

# Send Push notification when command finished
eval "$(ntfy shell-integration)"

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ $GIT_AUTHOR_NAME ]]; then
    export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
    export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

    git config --global user.name "$GIT_AUTHOR_NAME"
    git config --global user.email "$GIT_AUTHOR_EMAIL"
    git config --global user.mail "$GIT_AUTHOR_EMAIL"

    git config --global color.ui true
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    # git config --global credential.helper osxkeychain
fi

# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi

# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
