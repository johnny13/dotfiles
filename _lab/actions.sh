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

initializeRC()
{
    local rcDir
    rcDir="${HOME}/.dotfiles"

    if is_not_dir "${rcDir}"; then
        #echoMiniHeader

        run_banner "● ❯❯❯❯❯ ◆ First Time Setup ◆ ❮❮❮❮❮ ●" "━" 36

        mkdir -p "${rcDir}"

        git clone ""

        pause
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
            if [ "${NN}" != "05_imports.sh" ]; then
                cat "${fbash}" >>"${final_file}"
                printf "\n" >>"${final_file}"
            fi
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
    echo "Installing yadm via git..."
    mkdir -p ~/.code ~/.code/bin
    git clone https://github.com/TheLocehiliosan/yadm.git ~/.code/yadm
    ln -sf ~/.code/yadm/yadm ~/.code/bin/
    export PATH="~/.code/bin:$PATH"
}

createNewShellScript()
{
    # Prompt for Name

    # Prompt for Type

    #   Type 1: Single Function
    #   Type 2: Parameter Script
    #   --> If 1 or 2
    #           Launch ASCII Header Builder
    #           Copy Template Files to new dir

    #   Type 3: Laravel Zero    (Menu Heavy)
    #   Type 4: NodeJS Template (TUI)
    #   --> If 3 or 4
    #           Copy Template Files

    echo "TODO!"
}
