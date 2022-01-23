# CLI KNOWLEDGE BASE
# INFO https://github.com/gnebbia/kb
alias kbl="kb list"
alias kbe="kb edit"
alias kba="kb add"
alias kbv="kb view"
alias kbd="kb delete --id"
alias kbg="kb grep"
alias kbt="kb list --tags"

###
## FZF DEFAULTS
###

#export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
#export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules' --color=always"
export FZF_DEFAULT_COMMAND='find -L . -type f -o -type d -o -type l | sed 1d | cut -b3- | grep -v -e .git/ -e .svn/ -e .hg/'

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_COMPLETION_OPTS='--info=inline --extended'
export FZF_DEFAULT_OPTS='
--layout=reverse
--info=inline
--height=80%
--margin=2,2,2,2
--padding=1,1,1,1
--multi
--preview-window=:hidden
--preview "([[ -f {} ]] && (bat --style=numbers --color=always --line-range :500 {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200"
--prompt="∘⬣ "
--pointer="▶"
--marker="■"
--ansi
--bind ?:toggle-preview
--bind ctrl-a:select-all
--bind ctrl-y:execute-silent(echo {+} | pbcopy)
--bind ctrl-e:execute(echo {+} | xargs -o micro)
--bind ctrl-v:execute(code {+})
'

_gen_fzf_theme()
                {

   color00='#2d2d2d'
   color01='#393939'
   color02='#515151'
   color03='#999999'
   color04='#b4b7b4'
   color05='#cccccc'
   color06='#e0e0e0'
   color07='#ffffff'
   color08='#f2777a'
   color09='#f99157'
   color0A='#ffcc66'
   color0B='#99cc99'
   color0C='#66cccc'
   color0D='#6699cc'
   color0E='#cc99cc'
   color0F='#a3685a'

  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:$color00,spinner:$color0C,hl:$color0D --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

}
_gen_fzf_theme

_fzf_compgen_path()
                    {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir()
                   {
  fd --type d --hidden --follow --exclude ".git" . "$1"
  #exa -T --color always --icons -F -D
}

# _fzf_comprun() {
#   command=$1
#   shift

#   case "$command" in
#     cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
#     export | unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
#     ssh)          fzf "$@" --preview 'dig {}' ;;
#     *)            fzf "$@" ;;
#   esac
# }

###
## FZF ALIASES & FUNCTIONS
###

fdir()
       {
  #fzf + rg configuration
  if _has fzf && _has rg; then
      export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      bind -x '"\C-p": micro $(fzf);'
  fi

  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2>/dev/null  | fzf +m) && cd "$dir"
}
alias fzf-dir='fdir'

fcd()
      {
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
alias fzf-cd='fcd'

fzfinfile()
            {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

alias fzf-fif='fzfinfile'

fzf_kill()
           {
    local pid_col

    if [[ $(uname) = Linux ]]; then
        pid_col=2
  elif   [[ $(uname) = Darwin ]]; then
        pid_col=3
  else
        echo 'Error: unknown platform'
        return
  fi

    local pids=$(ps -f -u $USER | sed 1d | fzf --multi | tr -s [:blank:] | cut -d ' ' -f "$pid_col")

    if [[ -n $pids ]]; then
        echo "$pids" | xargs kill -9 "$@"
  fi
}

alias fzf-kill='fzf_kill'

fzf_git_log()
              {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
  )
    if [[ -n $selections ]]; then
        local commits=$(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
        git show $commits
  fi
}

alias fzf-gitlog='fzf_git_log'

git config --global alias.ll 'log --graph --format="%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

alias fzf-view="fzf --height 100% --layout reverse --info inline --preview 'bat --theme=\"Coldark-Dark\" --color=always --style=numbers,header --line-range=:500 {}' --preview-window=right:70%:noborder"

# LastPass FZF integration
fzflp()
{
  lpass login derek@huement.com
  lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}

alias fzf-lp='fzflp'

alias fzf-micro='micro $(fzf)'

alias fzf-history='hstr | fzf'

alias fzf-apt='apt-cache search "" | sort | cut --delimiter " " --fields 1 | fzf --multi --cycle --reverse --preview "apt-cache show {1}" | xargs -r sudo apt install -y'

bind "$(bind -s | grep '^"\\C-r"' | sed 's/"/"\\C-x/' | sed 's/"$/\\C-m"/')"

# FZF $PATH Binaries
# INFO: https://www.charlesetc.com/fzf-your-path/
__fzf_binary__()
{
  local selected="$(compgen -c | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-80%}\
    --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@")"
  READLINE_LINE="\
  ${READLINE_LINE:0:$READLINE_POINT}\
  $selected${READLINE_LINE:$READLINE_POINT}"
  echo -ne "$selected"
  READLINE_POINT=$((READLINE_POINT + ${#selected}))
}
# bind to Control-h, change this if you want a different key
bind '"\C-h": " \C-e\C-u\C-y\ey\C-u`__fzf_binary__`\e\C-e\er\e^"'
# Required to refresh the prompt after fzf
bind '"\er": redraw-current-line'
bind '"\e^": history-expand-line'

unalias z
z()
    {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz()
     {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}

###
## Source FZF Script
###

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

make_bash_script()
{
    if [ $# -eq 0 ]; then
        PDIR=$(pwd)
        FILE="skeleton.sh"
        FLOC="${PDIR}/${FILE}"

        echo -e "\nGenerating 'skeleton.sh' bash script...\n"
  else
        FLOC="${1}"

        echo -e "\nGenerating blank script: ${1}\n"
  fi

    SKELETON_URL="https://gist.githubusercontent.com/johnny13/de39a024c79b4d7ee1e52e462f57a123/raw/fe08f3de2b023dee323914ad564a5d746f4c6348/bash_skeleton.sh"
    wget -O "${FLOC}" "${SKELETON_URL}"
    chmod +x "${FLOC}"
    micro "${FLOC}"
}
alias new_sh='make_bash_script'
alias fresh_bash='make_bash_script'

###
## COMPLEX ALIASES
###

backgroundcmd()
{
    echo "Backgrounding: ${1}"
    echo "Output Log:    /tmp/${1}.out"
    nohup $1 >/tmp/$1.out 2>&1
}
alias bgcmd='backgroundcmd'

rec_file_cmd()
{
    echo "Recursive File Processing"
    echo "-------------------------"
    shopt -s globstar
    shopt -s nullglob
    for file in **/*.{$@}; do
        echo "found: ${file}"
  done
}
alias recfiles='rec_file_cmd'

unzip_multiple()
{
    find -name '*.zip' -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;
}
alias unzipmulti='unzip_multiple'

# Easily extract all compressed file types
extract()
           {
   if [ -f "$1" ]; then
       case $1 in
           *.tar.bz2)   tar xvjf -- "$1"    ;;
           *.tar.gz)    tar xvzf -- "$1"    ;;
           *.bz2)       bunzip2 -- "$1"     ;;
           *.rar)       unrar x -- "$1"     ;;
           *.gz)        gunzip -- "$1"      ;;
           *.tar)       tar xvf -- "$1"     ;;
           *.tbz2)      tar xvjf -- "$1"    ;;
           *.tgz)       tar xvzf -- "$1"    ;;
           *.zip)       unzip -- "$1"       ;;
           *.Z)         uncompress -- "$1"  ;;
           *.7z)        7z x -- "$1"        ;;
           *)           echo "don't know how to extract '$1'..." ;;
    esac
  else
       echo "'$1' is not a valid file"
  fi
}

zip_multiple()
{
    for i in */; do zip -r "${i%/}.zip" "$i"; done
}
alias zipmulti='zip_multiple'

md_to_png()
{
    # @NOTE: Requires wkhtmltoimage
    md2png --bin /usr/local/bin/wkhtmltoimage --cssname jasonm23-dark -m "$1"
}
alias mdpng='md_to_png'
