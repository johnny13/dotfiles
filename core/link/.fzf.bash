# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lucky/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/lucky/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/lucky/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/lucky/.fzf/shell/key-bindings.bash"
