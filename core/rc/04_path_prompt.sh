# ------------------------

__prompt_command()
{
    local EXIT=${PIPESTATUS[-1]}            # This needs to be first

    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    PROMPTUSER=""
    if [ ${UID} -eq "0" ]; then
        PROMPTUSER+="ROOT"       ## Set prompt for root
    else
        PROMPTUSER+="${USER}"
    fi

    PROMPTEXIT=""
    if [ "${EXIT}" != 0 ]; then
        PROMPTEXIT+="🔴"     ## Add exit code, if non 0
    else
        PROMPTEXIT+="🎃"
    fi

    OSCPU=""
    if [ "${OSTYPE}" = "linux-gnu" ]; then
        CPUIDL="$(iostat --dec=0 -c | awk '/idle/{getline; print}' | awk '{ gsub(/ /,""); print }' | grep -o '..$')"
        PERCPU="$((100 - CPUIDL))"

        if [ $PERCPU -gt 80 ]; then
            OSCPU='⚅'
        elif [ $PERCPU -gt 60 ]; then
            OSCPU='⚄'
        elif [ $PERCPU -gt 40 ]; then
            OSCPU='⚃'
        elif [ $PERCPU -gt 30 ]; then
            OSCPU='⚂'
        elif [ $PERCPU -gt 20 ]; then
            OSCPU='⚁'
        else
            OSCPU='⚀'
        fi
    else
        OSCPU+=""
    fi

    #PROMPTGIT="⦵"
    PROMPTGIT=""
    if [[ $(command -v git) ]]; then
        if [ -d .git ]; then
            git_status=$(git status)
            if [[ $git_status =~ (On branch )([a-zA-Z0-9_-]+) ]]; then
                branch=${BASH_REMATCH[2]} #first perens
                stat=''
            fi
            if [[ $git_status =~ (Changes not staged for commit) ]]; then
                stat=' '$stat' ✱'
            fi
            if [[ $git_status =~ (Changes to be committed) ]]; then
                stat=' '$stat' ✚'
            fi
            if [[ $git_status =~ (ahead of|behind)(.*)([0-9]+) ]]; then
                pos=${BASH_REMATCH[1]}
                num=${BASH_REMATCH[3]}
                if [[ $pos =~ (ahead) ]]; then
                    stat=$stat' '$num' ▶'
                elif [[ $pos =~ (behind) ]]; then
                    stat=$stat' '$num' ◀'
                fi
            fi
            PROMPTGIT=" ${branch} ${stat} "
        fi
    fi
    ### End Git Status ###

    #PS1='\[\e[0m\][$PROMPTEXIT\[\e[0;48;5;46m\]\[\e[0m\]]\[\e[0m\]$PROMPTGIT\[\e[0m\]\[\e[0m\]\[\e[0;48;5;41m\] \[\e[0;38;5;254;48;5;41m\]\u\[\e[0;48;5;41m\] \[\e[0;48;5;62m\] \[\e[0;38;5;254;48;5;62m\]\w\[\e[0;38;5;254;48;5;62m\] \[\e[0;48;5;44m\] \[\e[0;1;38;5;254;48;5;44m\]$\[\e[0;48;5;44m\] \[\e[0m\] '

    PS1='\[\e[0m\]\n\[\e[0;38;5;254m\]┏━⟦$PROMPTEXIT⟧━━⦗⟪\[\e[0;38;5;41m\] \w \[\e[0;38;5;254m\]⟫⦘━━─❶❸ \n┃\n┗━┉⦗\[\e[0;38;5;44m\] $PROMPTUSER \[\e[0;38;5;254m\]⦘┉┉┉\[\e[0;38;5;172m\]$PROMPTGIT\[\e[0;38;5;254m\]┉⟮⦑\[\e[0;38;5;62m\]$OSCPU \[\e[0;38;5;254m\]⦒⟯\[\e[0m\] '

    # ensure synchronization between bash memory and history file
    history -a
    history -n

}

export PROMPT_DIRTRIM=2
export PROMPT_COMMAND=__prompt_command
export PS1 PROMPTEXIT PROMPTGIT PROMPTUSER OSCPU

__prompt_command

# MAIN PATH EXPORT
export PATH=$HOME/.local/rc/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/usr/local/go/bin:$GOPATH/bin:$HOME/.config/composer/vendor/bin:/usr/local/bin:/usr/bin:$PATH
