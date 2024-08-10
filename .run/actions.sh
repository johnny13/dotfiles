### -----------------------------------
### Actions File Sourced in via menu.sh
### -----------------------------------

removeSymlinks()
{
    # Clear out symlinks from directory
    find "$1" -type l -exec unlink {} \;
}

### -----------------------------------------------
### Profile Functions
### -----------------------------------------------

# This function is not called. Chicken and Egg thing. If you have this repo already installed, you dont need to install it.
# and inorder to use this function, the repo already needs to be installed...
initializeRC()
{
    local rcDir
    rcDir="${HOME}/.dotfiles"

    if is_not_dir "${rcDir}"; then
        #echoMiniHeader

        run_banner "● ❯❯❯❯❯ ◆ First Time Setup ◆ ❮❮❮❮❮ ●" "━" 36

        mkdir -p "${rcDir}"

        git clone "https://github.com/johnny13/dotfiles"

        pause
    else

        run_banner "● ❯❯❯❯❯ ◆ UPDATING RC ◆ ❮❮❮❮❮ ●" "━" 26
        cd "${rcDir}"
        git pull

    fi
}

## BACKUP CMD: Creates a backup of any dotfile passed to it.
## PARAMETERS: (NewBackupName, TargetBackupFile, OptionalVerbosness)
## ------------------------------------------------------------------------
dotBackup()
{

    STAMP=$(date +%s)
    DOTNAME=$(basename "$2")

    # If the requested Copy file already exists...
    if [ -f "$1" ]; then
        STATUS=$(
            cmp --silent "${1}" "${2}"
            echo $?
        )

        if [[ $STATUS -eq 0 ]]; then
            if [ -n "$3" ]; then
                OUTPUT_MSG "INFO" "$2 Unchanged"
            fi
        else
            if [ -n "$3" ]; then
                OUTPUT_MSG "GOOD" "Archive moved: vault/${DOTNAME}_${STAMP}."
                OUTPUT_MSG "GOOD" "New Backup: vault/${DOTNAME}"
            fi

            mv "$1" "${BASEDIR}/vault/${DOTNAME}_${STAMP}"
            cp -r "$2" "${BASEDIR}/vault/${DOTNAME}"
        fi
    else
        # create requested backup file as none was found.
        if [ -n "$3" ]; then
            OUTPUT_MSG "GOOD" "New Backup: vault/${DOTNAME}"
        fi
        cp -r "$2" "${BASEDIR}/vault/${DOTNAME}"
    fi
}

## ACTION: Build scripts into binaries & install into $PATH
## @TODO   NEED to ensure SHC Install is debian only
## PARAMS: Optionally set install target directory
## --------------------------------------------------------
shellScriptBinaryConversion()
{
    local binDir
    local buildDir
    binDir="${BASEDIR}/bin"
    buildDir="${BASEDIR}/.temp/scripts"
    shDir=$1

    run_banner "Script files setup" "x" 25

    if is_not_dir "${binDir}"; then
        mkdir -p "${binDir}"
    fi

    clearOutTempShellScripts

    mkdir -p "${buildDir}"

    if ! command -v shc &>/dev/null; then
        OUTPUT_MSG "WARN" "${BRED}shc${NORMAL} not found. installing now..."
        apt_or_brew_helperInstaller "shc"
    fi

    for entry in "${shDir}"/*; do
        if [ -f "$entry" ] && [[ $entry != .* ]]; then
            BSN="$(basename -- ${entry})"

            sed '/^# / d' <"${entry}" >"${buildDir}/${BSN}.temp"
            sed '$!N; /^\(.*\)\n\1$/!P; D' <"${buildDir}/${BSN}.temp" >"${buildDir}/${BSN}"

            rm "${buildDir}/${BSN}.temp"
        fi
    done

    shc=$(command -v shc)
    for shentry in "${buildDir}"/*.sh; do
        sout=$(basename "${shentry}" .sh)
        OUTPUT_MSG "MAKE" "Bundeling ${sout}"
        #  -i "-e" -x "exec(\\'%s\\',@ARGV);" -l "--"
        "${shc}" -f "${shentry}" -o "${buildDir}/${sout}" -r

        if [ -f "${shentry}.x.c" ]; then
            rm "${shentry}"
            rm "${shentry}.x.c"
        fi

    done

    for txtentry in "${shDir}"/*.txt; do
        if [ -f "${txtentry}" ]; then
            sout=$(basename "${txtentry}" .txt)
            cp "${txtentry}" "${buildDir}/${sout}.txt"
        fi
    done

    #OUTPUT_MSG "GOOD" "Copying Scripts to: ${binDir}"
    #cp -r "${buildDir}"/* "${binDir}"

    # Only copy scripts if their contents has changed
    for fScript in "${buildDir}"/*; do
        BSN=$(basename -- "${fScript}")
        NEW="${binDir}/${BSN}"

        # If exists, update if changed
        # which always has due to shc stuff. I think..
        # else just copy new file over
        if [ -f "${NEW}" ]; then
            STATUS=$(
                cmp --silent "${fScript}" "${NEW}"
                echo $?
            )

            if [[ $STATUS -eq 0 ]]; then
                OUTPUT_MSG "INFO" "${BSN} Unchanged. Skipping..."
            else
                OUTPUT_MSG "GOOD" "${BSN} Updated Successfully!"
                cp "${fScript}" "${NEW}"
            fi
        else
            OUTPUT_MSG "GOOD" "${BSN} Added to User Scripts!"
            cp "${fScript}" "${NEW}"
        fi

    done

    echo -e "\n\n"
}

## SUPPORT: Optionally add in local scripts
## -----------------------------------------------------------------
addLocalProfileSH()
{
    local hostname
    hostname=$(hostname)

    if [ -d "${BASEDIR}/local/${hostname}/sh" ]; then
        shellScriptBinaryConversion "${BASEDIR}/local/${hostname}/sh"
    fi

}

clearOutUserShellScripts()
{
    local binDir
    binDir="${HOME}/.local/rc/bash/bin"

    if [ -d "$binDir" ]; then
        rm -r "${binDir}"
    fi

    mkdir -p "${binDir}"
}

clearOutTempShellScripts()
{
    local binTempDir
    binTempDir="${BASEDIR}/.temp"

    if [ -d "$binTempDir" ]; then
        rm -r "${binTempDir}"
    fi
}

## ACTION: Box Setup Scripts
## ----------------------------------------------------
boxInstallScripts()
{
    debFile="${BASEDIR}/box/Debian/RUN.sh"
    macFile="${BASEDIR}/box/Darwin/RUN.sh"
    macTwoFile="${BASEDIR}/box/Darwin/FINISH.sh"
    macSettings="${BASEDIR}/box/Darwin/MONTEREY.sh"

    OUTPUT_MSG "INFO" "building DEBIAN setup script..."
    cat "${BASEDIR}/box/_start.sh" "${BASEDIR}/_box/_colors.sh" "${BASEDIR}/box/Debian/_install.sh" "${BASEDIR}/box/Debian/albert.sh" "${BASEDIR}/box/_end.sh" >$debFile

    OUTPUT_MSG "INFO" "building DARWIN Apps script..."
    cat "${BASEDIR}/box/_start.sh" "${BASEDIR}/box/Darwin/_utils.sh" "${BASEDIR}/box/Darwin/_monterey_prep.sh" "${BASEDIR}/box/Darwin/_monterey.sh" >$macFile

    OUTPUT_MSG "INFO" "building DARWIN Apps script..."
    cat "${BASEDIR}/box/_start.sh" "${BASEDIR}/box/Darwin/_utils.sh" "${BASEDIR}/box/Darwin/_monterey_pt2.sh" "${BASEDIR}/box/_end.sh" >$macTwoFile

    OUTPUT_MSG "INFO" "building DARWIN Settings script..."
    cat "${BASEDIR}/box/_start.sh" "${BASEDIR}/box/Darwin/_utils.sh" "${BASEDIR}/box/Darwin/_monterey_settings.sh" >$macSettings

    deb_size_kb=$(du -k "$debFile" | cut -f1)
    mac_size_kb=$(du -k "$macFile" | cut -f1)
    mtf_size_kb=$(du -k "$macTwoFile" | cut -f1)
    mty_size_kb=$(du -k "$macSettings" | cut -f1)

    echo -e "\n\n\n\t\t${BCYN}Debian File Size:   ${BGRN}${deb_size_kb} KB${NORMAL}\n"
    echo -e "\t\t ${BCYN}MacOS File Size:   ${BGRN}${mac_size_kb} KB${NORMAL}\n"
    echo -e "\t\t ${BCYN} MacOS End Size:   ${BGRN}${mtf_size_kb} KB${NORMAL}\n"
    echo -e "\t\t ${BCYN}  Monterey Size:   ${BGRN}${mty_size_kb} KB${NORMAL}\n"

    echo -e "\n\t${BBLU}Files can be found at ${BGRN}box/${BYLW}<OS TYPE>${BGRN}/RUN.sh ${NORMAL}\n\n\n${BPUR}"
}

gitCommit()
{
    echo ''
    echo 'git add *'
    echo 'git commit -m "feat: <example feature>"'
    echo 'git push'
    echo ''
}

## ACTION: When setting up a new machine, these are the default dotfiles that
##         need to be copied over.
## --------------------------------------------
## ACTION: Initial install of default dot files
## --------------------------------------------
dotfileCOPY()
{
    cd "${BASEDIR}" || exit
    find . -name ".DS_Store" -delete

    # COPY Default Dots to Home
    if [ -d "${BASEDIR}/boxes/defaults/copy" ]; then
        OUTPUT_MSG "INFO" "COPY from boxes/defaults/copy to ${HOME}"
        for cbash in "${BASEDIR}"/boxes/defaults/copy/*; do
            if [ -f "${cbash}" ]; then
                PathName="${cbash##*/}"
                BaseName="${PathName%.*}"
                if [ -f "${HOME}/.${BaseName}" ]; then
                    dotBackup "${BASEDIR}/vault/${BaseName}" "${HOME}/.${BaseName}"
                    rm "${HOME}/.${BaseName}"
                fi
                cp "${cbash}" "${HOME}/.${BaseName}"
            fi
        done
    fi

    # LINK Default Dots to Home
    hostname=$(hostname)
    if [ -d "${BASEDIR}/local/${hostname}/copy" ]; then
        OUTPUT_MSG "INFO" "COPY from local/${hostname}/copy to ${HOME}"
        for lbash in "${BASEDIR}/local/${hostname}"/copy/*; do
            if [ -f "${lbash}" ]; then
                PathName="${lbash##*/}"
                BaseName="${PathName%.*}"
                if [ -f "${HOME}/.${BaseName}" ]; then
                    dotBackup "${BASEDIR}/vault/${BaseName}" "${HOME}/.${BaseName}"
                    rm "${HOME}/.${BaseName}"
                fi
                cp "${lbash}" "${HOME}/.${BaseName}"
            fi
        done
    fi
}

## ACTION: When setting up a new machine, these are the default dotfiles that
##         are symlinked
## ------------------------------------------------
dotfileLINK()
{

    if _hasCMD "lndir"; then
        if [ -d "${BASEDIR}/boxes/defaults/link" ]; then
            OUTPUT_MSG "INFO" "Linking boxes/defaults/link to ${HOME}"

            cd "${HOME}" || return

            lndir "${BASEDIR}/boxes/default/link"
        fi

        # sudo apt-get install xutils-dev
        if [ -d "${BASEDIR}/local/${hostname}/link" ]; then
            OUTPUT_MSG "INFO" "Linking ${hostname}/link to ${HOME}"

            cd "${HOME}" || return

            lndir "${BASEDIR}/local/${hostname}/link"
        fi

        cd "${BASEDIR}" || return
    else
        OUTPUT_MSG "INFO" "lndir not installed. Install via apt-get or homrebew"
        apt_or_brew_helperInstaller "lndir"
    fi

}

### -----------------------------------------------
### ....
### -----------------------------------------------

### -----------------------------------------------
### CLI TOOLS
### -----------------------------------------------

installYADM()
{
    OUTPUT_MSG "INFO" "Installing yadm via git..."
    mkdir -p ~/.code ~/.code/bin
    git clone https://github.com/TheLocehiliosan/yadm.git ~/.code/yadm
    ln -sf ~/.code/yadm/yadm ~/.code/bin/
    export PATH="~/.code/bin:$PATH"
}

createNewShellScript()
{
    # Prompt for Name
    ansi::bold
    ansi::color 11

    cd "${BASEDIR}" || exit
    cat ./var/ascii/newshellscript.txt
    echo -e "\n\n"

    #echo -e "\n     Creating New Shell Script\n\n"
    message="     what to use for filename? (no extension) :  "
    read -rp "$message" NEWFILENAME

    # We cant know the extension until AFTER they set what type of script
    #fname="${NEWFILENAME}.sh"

    echo ""

    message="     where to create file? [ex: /my/saved/path] :  "
    read -rp "$message" NEWFILEPATH

    # strip trailing slash & check if valid
    TRIMMED=$(echo $NEWFILEPATH | sed 's:/*$::')
    if [[ ! -d "$TRIMMED" ]]; then
        OUTPUT_MSG "INFO" "Path: ${TRIMMED} being created"
        mkdir -p "${TRIMMED}"

        if [[ ! -d "$TRIMMED" ]]; then
            OUTPUT_MSG "FAIL" "Directory Wasnt created for some reason! Exiting for safety!"
        fi

    else
        OUTPUT_MSG "FAIL" "Directory already exists! Exiting for safety!"
    fi

    echo ""

    message="     Brief description of ${NEWFILENAME}:  "
    read -rp "$message" NEWdetails
    details="${NEWdetails}"

    email="derek@huement.com"

    echo ""

    echo -e "\n\n     What type of template to use for ${NEWFILENAME}?\n"
    ansi::color 45
    echo "     ━ •• ━━━━━ •• ━━ •• ━━━ ••• ━"
    echo "     "
    echo -e "       ${BGRN}1 ${BCYN}| ${BYLW}Simple Single Function ${BPUR}[.sh] ${NORMAL}"
    echo -e "       ${BGRN}2 ${BCYN}| ${BYLW}Multiple Input Parameters ${BPUR}[.sh] ${NORMAL}"
    echo -e "       ${BGRN}3 ${BCYN}| ${BYLW}Laravel Zero ${BPUR}[.php] ${NORMAL}"
    echo -e "       ${BGRN}4 ${BCYN}| ${BYLW}NodeJS Tempalte ${BPUR}[.js] ${NORMAL}"
    echo "     "
    ansi::color 45
    echo "     ━ •• ━━━━━ •• ━━ •• ━━━ ••• ━"
    echo "     "

    ansi::color 11
    read -n 1 -s option </dev/tty
    case "$option" in
        1)
            echo -e "     ${BGRN}  Simple Function Selected!\n"
            buildNewScript 1
            ;;
        2)
            echo -e "     ${BGRN}  Multiple Input Selected!\n"
            buildNewScript 2
            ;;
        3)
            echo -e "     ${BGRN}  Laravel Zero Selected!\n"
            buildNewLaravel
            ;;
        4)
            echo -e "     ${BGRN}  NodeJS Selected!\n"
            buildNewNode
            ;;
        *)
            OUTPUT_MSG "FAIL" "Bad choice!!!! Exiting for safety!"
            ;;
    esac
    echo ""

    ansi::resetForeground
}

buildNewScript()
{

    ## Note: $TRIMMED has been created already by this point.
    ##       That is where the file(s) should end up.

    CHOICE=$1

    if [[ $CHOICE -eq 1 ]]; then
        BASEFILE="${BASEDIR}/var/templates/bash-quick/run.sh"
    fi

    if [[ $CHOICE -eq 2 ]]; then
        BASEFILE="${BASEDIR}/var/templates/bash-full/_base.sh"
    fi

    ## SHELL SCRIPT OPTION
    if [[ $CHOICE -eq 1 ]] || [[ $CHOICE -eq 2 ]]; then
        NFILE="${TRIMMED}/${NEWFILENAME}.sh"
        NNAME="${NEWFILENAME}.sh"
        cp "${BASEFILE}" "${NFILE}"
        OUTPUT_MSG "INFO" "Copying: ${BASEFILE} to ${NFILE}"
    fi

    OUTPUT_MSG "INFO" "Setting up new script...."

    search="xSCRIPTNAMEx"
    replace="${NNAME}"
    sed -i "s|$search|$replace|g" "${NFILE}"

    search='xSCRIPTDETAILSx'

    replace="${details}"
    sed -i "s|$search|$replace|g" "${NFILE}"

    search='xAUTHOREMAILx'
    replace="${email}"
    sed -i "s|$search|$replace|g" "${NFILE}"

    search='xSCRIPTVERSIONx'
    replace='0.0.1'
    sed -i "s|$search|$replace|g" "${NFILE}"

    search='xTODAYSDATEx'
    replace=$(date +'%Y-%m-%d_%H')
    sed -i "s|$search|$replace|g" "${NFILE}"

    chmod +x "${NFILE}"

    if [[ $CHOICE -eq 2 ]]; then
        OUTPUT_MSG "INFO" "Adding additional libraries..."
        BASED="${BASEDIR}"/var/templates/bash-full

        cp -r "${BASED}"/* "${TRIMMED}"/
        rm "${TRIMMED}/_base.sh"
    fi

    OUTPUT_MSG "GOOD" "Final Output Available Here: ${NFILE}"

    echo ""
}

buildNewLaravel()
{
    echo -e "\n\nTODO ADD PHP PROJECT\n"
}

buildNewNode()
{
    echo -e "\n\nTODO ADD NODE.js PROJECT\n"
}

addNewUser()
{
    ansi::bold
    ansi::color 11
    echo -e "\n     Adding New Dotfile Setup\n\n"
    message="     new machine username? :  "
    read -rp "$message" USERNAME
    ansi::resetForeground

    OUTPUT_MSG "INFO" "Creating local user ${USERNAME}..."

    mkdir -p "${BASEDIR}/local/${USERNAME}"
    mkdir -p "${BASEDIR}/local/${USERNAME}/copy"
    mkdir -p "${BASEDIR}/local/${USERNAME}/link"
    mkdir -p "${BASEDIR}/local/${USERNAME}/scripts"

    touch "${BASEDIR}/local/${USERNAME}/copy/.gitkeep"
    touch "${BASEDIR}/local/${USERNAME}/link/.gitkeep"
    touch "${BASEDIR}/local/${USERNAME}/scripts/.gitkeep"

    OUTPUT_MSG "INFO" "Finished creating directories"
}

keyboardHelp()
{
    ansi::color 45

    echo -e "\n\n"

    cat <<EOF
    Ctrl + A  Go to the beginning of the line you are currently typing on
    Ctrl + E  Go to the end of the line you are currently typing on
    Ctrl + L  Clears the Screen, similar to the clear command
    Ctrl + U  Clears the line before the cursor position. If you are at the end of the line, clears the entire line.
    Ctrl + H  Same as backspace
    Ctrl + R  Let’s you search through previously used commands
    Ctrl + C  Kill whatever you are running
    Ctrl + D  Exit the current shell
    Ctrl + Z  Puts whatever you are running into a suspended background process. fg restores it.
    Ctrl + W  Delete the word before the cursor
    Ctrl + K  Clear the line after the cursor
    Ctrl + T  Swap the last two characters before the cursor
    Esc + T  Swap the last two words before the cursor
    Alt + F  Move cursor forward one word on the current line
    Alt + B  Move cursor backward one word on the current line
    Tab Auto-complete files and folder names
EOF

    ansi::resetForeground
    echo -e "\n\n"

}
