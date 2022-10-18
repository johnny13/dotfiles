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

## ACTION: Buildes out bashrc-debug.sh
##         from files in core/rc and
##         includes links to files in core/alt
## ---------------------------------------------
buildBashRC()
{
    ansi::green

    run_banner "Building .bashrc file" "o" 25

    #addRCImports

    addLocalProfileRC

    final_file="${BASEDIR}/core/bashrc-debug.sh"

    search_dir=$(pwd)

    if [ -f "${final_file}" ]; then
        rm "${final_file}"
    fi

    for fbash in "${search_dir}"/core/rc/*.sh; do
        if [ -f "$fbash" ]; then
            NN=$(basename "${fbash}")
            # if [ "${NN}" != "05_imports.sh" ]; then
            #     cat "${fbash}" >>"${final_file}"
            #     printf "\n" >>"${final_file}"
            # fi
            cat "${fbash}" >>"${final_file}"
            printf "\n" >>"${final_file}"
        fi
    done

    # if [ -f "${search_dir}"/core/rc/05_temp.sh ]; then
    #     rm "${search_dir}"/core/rc/05_temp.sh
    # fi

    if [ -f "${search_dir}"/core/rc/01_local.sh ]; then
        rm "${search_dir}"/core/rc/01_local.sh
    fi

    activateNewDotfile ".bashrc" "${final_file}"

    OUTPUT_MSG "MERG" "core/rc files merged! .bashrc Ready!"
}

## SUPPORT: Called anytime a file is moved into the Home directory
## PARAMS:  ("HOMEDIR/FILE" "CORE/FILE" "OPTIONAL: COPY or MOVE+SOURCE")
## ---------------------------------------------------------------------
activateNewDotfile()
{
    local USERDIR
    local NEWMINNAME
    local TFILE

    USERDIR="/home/${USER}"
    NEWMINNAME=$(basename "${2}")
    TFILE="${USERDIR}/${1}"

    if [ -f "${TFILE}" ]; then
        dotBackup "${BASEDIR}/vault/${1}" "${TFILE}"
    fi

    if [ -n "$3" ]; then
        cp "${2}" "${TFILE}"
        OUTPUT_MSG "INFO" "COPIED: ${NEWMINNAME} ==> ${USER}/${1}"
    else
        mv "${2}" "${TFILE}"
        source_if_exists "${TFILE}"
        OUTPUT_MSG "GOOD" "ACTIVATED: ${NEWMINNAME} ==> ${USER}/${1}"
    fi
}

## SUPPORT: Called from buildBashRC to generate list of all
##          files in core/alt that need to be sourced
## --------------------------------------------------------
addRCImports()
{
    ##
    ## WARNING: THIS IS NOT USED AT THE MOMENT. UNCLEAR WHAT IS WAS USED FOR
    ##

    local rand_string
    local import_file
    local TFILE

    rand_string="$(uuidgen)"
    import_file="/tmp/${rand_string}.sh"

    search_dir="$(pwd)"

    if [ -f "${import_file}" ]; then
        rm "${import_file}"
    fi

    printf "\n" >>"${import_file}"

    cat "${search_dir}/core/rc/05_imports.sh" >>"${import_file}"

    printf "\n" >>"${import_file}"

    for fbash in "${search_dir}"/core/alt/*.sh; do
        NN=$(basename "${fbash}" .sh)
        printf "source_if_exists %s/.%s \n" "${HOME}" "${NN}" >>"${import_file}"
        activateNewDotfile ".${NN}" "${fbash}" "true"
    done

    printf "\n" >>"${import_file}"

    mv "${import_file}" "${search_dir}"/core/rc/05_temp.sh

    OUTPUT_MSG "INFO" "Auto generated includes GTG!"
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
    binDir="${HOME}/.local/rc/bin"
    buildDir="${BASEDIR}/temp/scripts"
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

clearOutUserShellScripts()
{
    local binDir
    binDir="${HOME}/.local/rc/bin"

    if [ -d "$binDir" ]; then
        rm -r "${binDir}"
    fi

    mkdir -p "${binDir}"
}

clearOutTempShellScripts()
{
    local binTempDir
    binTempDir="${BASEDIR}/temp"

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

## ACTION: Initial install icons & ascii art into $HOME
## ----------------------------------------------------
dotfileMEDIA()
{
    if is_not_dir "${HOME}"/.local/rc/icons; then
        mkdir -p "${HOME}"/.local/rc/icons
    fi

    if is_not_dir "${HOME}"/.local/rc/ascii; then
        mkdir -p "${HOME}"/.local/rc/ascii
    fi

    OUTPUT_MSG "INFO" "setting up ascii & icons"
    cp -r "${BASEDIR}"/media/icons/* "${HOME}/.local/rc/icons"
    cp -r "${BASEDIR}"/media/ascii/* "${HOME}/.local/rc/ascii"
}

## ACTION: Initial install of default dot files
## --------------------------------------------
dotfileCOPY()
{
    # COPY copy folder(s) to Home directory
    if [ -d "${BASEDIR}/core/copy" ]; then
        OUTPUT_MSG "INFO" "Copying files from core/copy to ${HOME}"
        for cbash in "${BASEDIR}"/core/copy/*.sh; do
            if [ -f "${cbash}" ]; then
                NN=$(basename "${cbash}" .sh)
                cp "${cbash}" "${HOME}/.${NN}"
            fi
        done
    fi

    # Local Starter Dots
    hostname=$(hostname)
    if [ -d "${BASEDIR}/local/${hostname}/copy" ]; then
        OUTPUT_MSG "INFO" "Copying files from local/${hostname}/copy to ${HOME}"
        for lbash in "${BASEDIR}"/local/"${hostname}"/copy/*.sh; do
            if [ -f "${lbash}" ]; then
                NN=$(basename "${lbash}" .sh)
                cp "${lbash}" "${HOME}/.${NN}"
            fi
        done
    fi
}

## ACTION: Link linked directory to home
## ------------------------------------------------
dotfileLINK()
{

    if _hasCMD "lndir"; then
        if [ -d "${BASEDIR}/core/link" ]; then
            OUTPUT_MSG "INFO" "Linking core/link to ${HOME}"

            cd "${HOME}" || return

            lndir "${BASEDIR}/core/link"
        fi

        # sudo apt-get install xutils-dev
        if [ -d "${BASEDIR}/core/link" ]; then
            OUTPUT_MSG "INFO" "Linking core/link to ${HOME}"

            cd "${HOME}" || return

            lndir "${BASEDIR}/local/${hostname}/link"
        fi

        cd "${BASEDIR}" || return
    else
        OUTPUT_MSG "INFO" "lndir not installed. Installing!!"

        # TODO Make sure this only fires on Ubuntu. Or figure out how to do homebrew as well.
        sudo apt-get install xutils-dev
    fi

}

### -----------------------------------------------
### Local Items Loaded in based on Machine hostname
### -----------------------------------------------

## SUPPORT: Optionally add in local bashrc
## -----------------------------------------------------------------
addLocalProfileRC()
{
    hostname=$(hostname)

    if [ -d "${BASEDIR}/local/${hostname}/rc" ]; then
        finalFile="${BASEDIR}/core/rc/01_local.sh"

        for lbash in "${BASEDIR}"/local/"${hostname}"/rc/*.sh; do
            NN=$(basename "${lbash}")
            cat "${lbash}" >>"${finalFile}"
            echo -e "\n\n" >>"${finalFile}"
        done
    fi

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
    echo -e "\n     Creating New Shell Script\n\n"
    message="     what to use for filename? :  "
    read -rp "$message" NEWFILENAME

    fname="${NEWFILENAME}.sh"

    echo ""

    message="     where to create file? [ex: /my/saved/path] :  "
    read -rp "$message" NEWFILEPATH

    fpath="${NEWFILEPATH}"

    # strip trailing slash & check if valid
    TRIMMED=$(echo $fpath | sed 's:/*$::')
    if [[ ! -d "$TRIMMED" ]]; then
        OUTPUT_MSG "FAIL" "ERROR! Path: ${TRIMMED} not found."
    fi

    # confirm file doesnt already exist
    NFILE="${TRIMMED}/${fname}"
    if is_file "${NFILE}"; then
        OUTPUT_MSG "FAIL" "File already exists! Exiting... :("
    fi

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
            echo -e "     ${BRED}     Bad choice!!!${NORMAL}\n\n" && exit
            ;;
    esac
    echo ""

    ansi::resetForeground
}

buildNewScript()
{
    CHOICE="$1"

    if [[ $CHOICE -eq 1 ]]; then
        #echo " Build Simple"
        BASEFILE="${BASEDIR}/new/SHELL/template_quick/run.sh"
        cp "${BASEFILE}" "${NFILE}"
    fi

    if [[ $CHOICE -eq 2 ]]; then
        #echo " Build Complex"
        mkdir -p "${NEWFILEPATH}/${NEWFILENAME}"
        BASEFILE="${BASEDIR}/new/SHELL/template/run.sh"
        cp "${BASEFILE}" "${NEWFILEPATH}/${NEWFILENAME}/${NEWFILENAME}.sh"
        NFILE="${NEWFILEPATH}/${NEWFILENAME}/${NEWFILENAME}.sh"
    fi

    OUTPUT_MSG "INFO" "Setting up new script...."

    search="xSCRIPTNAMEx"
    replace="${fname}"
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
        BASED="${BASEDIR}/new/SHELL/template/docs"
        BASEE="${BASEDIR}/new/SHELL/template/exmaples"
        BASEL="${BASEDIR}/new/SHELL/template/library"

        cp -r "${BASED}" "${NEWFILEPATH}/${NEWFILENAME}"
        cp -r "${BASEE}" "${NEWFILEPATH}/${NEWFILENAME}"
        cp -r "${BASEL}" "${NEWFILEPATH}/${NEWFILENAME}"
    fi

    OUTPUT_MSG "GOOD" "  Final Output Available Here: ${NFILE}"

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
    #ansi::color 45
    ansi::resetForeground

    OUTPUT_MSG "INFO" "Creating local user ${USERNAME}..."

    mkdir -p "${BASEDIR}/local/${USERNAME}"
    mkdir -p "${BASEDIR}/local/${USERNAME}/copy"
    mkdir -p "${BASEDIR}/local/${USERNAME}/link"
    mkdir -p "${BASEDIR}/local/${USERNAME}/rc"
    mkdir -p "${BASEDIR}/local/${USERNAME}/sh"

    touch "${BASEDIR}/local/${USERNAME}/copy/.gitkeep"
    touch "${BASEDIR}/local/${USERNAME}/link/.gitkeep"
    touch "${BASEDIR}/local/${USERNAME}/rc/.gitkeep"
    touch "${BASEDIR}/local/${USERNAME}/sh/.gitkeep"

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
