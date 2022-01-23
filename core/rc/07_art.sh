###
## CLI ART CMDS
###

## FIGLET & ASCII TEXT
## --------------------------
alias figcol='fig colossal'
alias figcolbash='figbash colossal'
alias figcolcss='figcss colossal'
alias figgra='fig graffiti'
alias figgrabash='figbash graffiti'
alias figgracss='figcss graffiti'

alias figbig='figlet -f big'
alias figsm='figlet -f small'
alias figunv='figlet -f univers'

function fighelp
                 {
    echo -en  "\n${BGRN}FIGLET HELP\n${NORMAL}Three output modes:\n${NORMAL}1. ${BGRN}Regular   ${NORMAL}2. ${BGRN}Bash Comment   ${NORMAL}3. ${BGRN}JS/CSS Comment\n\n${BBLU}"
    echo "fig <fontname> | figlet -S -f <var1> <var2> | sed 's/^/  /'"
    echo "figbash <fontname> | figlet -s -f <var1> <var2> | sed 's/^/  /' | sed 's/^\([^#]\)/#\1/g | sed 's/^/ /'"
    echo "figcss <fontname> | figlet -s -f <var1> <var2> | sed 's/^/  /' | sed 's/^\([^*]\)/*\1/g' | sed 's/^/ /'"
    echo -en  "\n\n${NORMAL}"
}

function fig
             {
    figlet -w 200 -c -o -f $1 $2 | sed 's/^/  /'
}

function figbash
                 {
    figlet -o -f $1 $2 | sed 's/^/  /' | sed 's/^\([^#]\)/#\1/g' | sed 's/^/ /'
}

function figcss
                {
    figlet -o -f $1 $2 | sed 's/^/  /' | sed 's/^\([^*]\)/*\1/g' | sed 's/^/ /'
}

## CLI IMG CMDS
## --------------------------
alias primitive-lips='primitive -bg 333333 -m 0 -n 20 -o ~/Pictures/test/%d.png -rep 5 -v -i ~/Pictures/Lips_Eye-01.png'

alias rainbowsmile='termpix ~/Pictures/RainbowSmile.png --max-width 40 --max-height 40 --true-color'
