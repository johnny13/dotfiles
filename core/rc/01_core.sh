#      ______  __  __   __   ______  ______  ______   ______   __   __
#     /\__  _\/\ \_\ \ /\ \ /\  == \/\__  _\/\  ___\ /\  ___\ /\ "-.\ \
#     \/_/\ \/\ \  __ \\ \ \\ \  __<\/_/\ \/\ \  __\ \ \  __\ \ \ \-.  \
#        \ \_\ \ \_\ \_\\ \_\\ \_\ \_\ \ \_\ \ \_____\\ \_____\\ \_\\"\_\
#         \/_/  \/_/\/_/ \/_/ \/_/ /_/  \/_/  \/_____/ \/_____/ \/_/ \/_/
#
#    .--.      .--.     .--.      .--.      .--.      .--.      .--.      .--.
#  :::::.\::::::::.\::::::::.\::::::::.\::::::::.\[X77777X]\::::::::.\::::::::.\::
#         '--'      '--'      '--'      '--'      '--'      '--'      '--'      '

[[ $- != *i* ]] && return

stty stop undef
stty start undef

# Source a file if it exists
source_if_exists()
{
    if [ -f "$1" ]; then
        . "$1"
    fi
}

# Returns whether the given command is executable or aliased.
_has()
{
    return $(which $1 >/dev/null)
}

###
## TERMINAL COLOR PALETTES & THEMES
###

colors_supported()
{
    command -v tput >/dev/null 2>&1 && (tput setaf || tput AF) >/dev/null 2>&1
}

if colors_supported; then
    CF="${HOME}/.01_colors_tput"
else
    CF="${HOME}/.01_colors_esc"
fi

source_if_exists "${CF}"

if ! command -v vivid &>/dev/null; then
    export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
else
    LS_COLORS="$(vivid generate jellybeans)"
    export LS_COLORS
fi

GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS

# export BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] &&
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] &&
#     eval '$("$BASE16_SHELL/profile_helper.sh")'

export LPASS_ASKPASS="${HOME}/Developer/askpass.sh"
export LPASS_AGENT_TIMEOUT=0
export LPASS_DISABLE_PINENTRY=1
