### -----------------------------------
### Actions File Sourced in via menu.sh
### -----------------------------------

gitAutoCommit()
{
	git add --all                         
	now=$(date)                           
	git commit -m "feat: auto-commit at : $now"
	git push -u origin main
	git status
}

cleanFiles()
{
	echo -e "\tCLEANING| ${1}"
	cd $1
	find . -name ".DS_Store" -delete
}


testFunction()
{
  # local binDir
  # local buildDir
  # binDir="${BASEDIR}/bin"
  # buildDir="${BASEDIR}/.temp/scripts"
  # shDir=$1
  #   echo -e "\n\nTODO ADD NODE.js PROJECT\n"
	
  # Prompt for Name
  ansi::bold
  ansi::color 11

  cd "${BASEDIR}" || exit
  cat "${BASEDIR}/rice/ascii-art/newshellscript.txt"
  echo -e "\n\n"

  #echo -e "\n     Creating New Shell Script\n\n"
  message="     what to use for filename? (no extension) :  "
  read -rp "$message" NEWFILENAME

  # We cant know the extension until AFTER they set what type of script
  fname="${NEWFILENAME}.sh"

  echo "${fname} is what was typed"
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