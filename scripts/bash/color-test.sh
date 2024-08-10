#!/usr/local/bin/bash
#/ ----------------------------------------
#/ |  DR. BASH'S COLOR TESTING FUN HOUSE  |
#/ ----------------------------------------
#/
#/ Usage: ./color_test [1-7]
#/
#/ opts:
#/      -h | --help) show this help and exit
#/
#/      1) 8 Bit Codes
#/      2) 16 Bit Table
#/      3) 24 Bit Codes
#/      4) 256 Bit Blocks
#/      5) 256 Bit Rainbow
#/      6) Invaders
#/      7) 6's
#/      8) DNA
#/      9) Ghosts
#/

printable_colours=256

# Return a colour that contrasts with the given colour
# Bash only does integer division, so keep it integral
function contrast_colour
                         {
    local r g b luminance
    colour="$1"

    if ((colour < 16)); then   # Initial 16 ANSI colours
        ((colour == 0))   && printf "15" || printf "0"
        return
    fi

    # Greyscale # rgb_R = rgb_G = rgb_B = (number - 232) * 10 + 8
    if ((colour > 231)); then   # Greyscale ramp
        ((colour < 244))   && printf "15" || printf "0"
        return
    fi

    # All other colours:
    # 6x6x6 colour cube = 16 + 36*R + 6*G + B  # Where RGB are [0..5]
    # See http://stackoverflow.com/a/27165165/5353461

    # r=$(( (colour-16) / 36 ))
    g=$((((colour - 16) % 36) / 6))
    # b=$(( (colour-16) % 6 ))

    # If luminance is bright, print number in black, white otherwise.
    # Green contributes 587/1000 to human perceived luminance - ITU R-REC-BT.601
    ((g > 2))  && printf "0" || printf "15"
    return

    # Uncomment the below for more precise luminance calculations

    # # Calculate percieved brightness
    # # See https://www.w3.org/TR/AERT#color-contrast
    # # and http://www.itu.int/rec/R-REC-BT.601
    # # Luminance is in range 0..5000 as each value is 0..5
    # luminance=$(( (r * 299) + (g * 587) + (b * 114) ))
    # (( $luminance > 2500 )) && printf "0" || printf "15"
}

# Print a coloured block with the number of that colour
function print_colour
                      {
    local colour="$1" contrast
    contrast=$(contrast_colour "$1")
    printf "\e[48;5;%sm" "$colour"                # Start block of colour
    printf "\e[38;5;%sm%3d" "$contrast" "$colour" # In contrast, print number
    printf "\e[0m "                               # Reset colour
}

# Starting at $1, print a run of $2 colours
function print_run
                   {
    local i
    for ((i = "$1"; i < "$1" + "$2" && i < printable_colours; i++)); do
        print_colour "$i"
    done
    printf "  "
}

# Print blocks of colours
function print_blocks
                      {
    local start="$1" i
    local end="$2" # inclusive
    local block_cols="$3"
    local block_rows="$4"
    local blocks_per_line="$5"
    local block_length=$((block_cols * block_rows))

    # Print sets of blocks
    for ((i = start; i <= end; i += (blocks_per_line - 1) * block_length)); do
        printf "\n" # Space before each set of blocks
        # For each block row
        for ((row = 0; row < block_rows; row++)); do
            # Print block columns for all blocks on the line
            for ((block = 0; block < blocks_per_line; block++)); do
                print_run $((i + (block * block_length)))   "$block_cols"
            done
            ((i += block_cols))   # Prepare to print the next row
            printf "\n"
        done
    done
}

function theTwoFiveSix
                       {
    print_run 0 16 # The first 16 colours are spread over the whole spectrum
    printf "\n"
    print_blocks 16 231 6 6 3 # 6x6x6 colour cube between 16 and 231 inclusive
    print_blocks 232 255 12 2 1 # Not 50, but 24 Shades of Grey
}

function colortable
{
    echo
    echo Table for 16-color terminal escape sequences.
    echo Replace ESC with \\ 033 in bash.
    echo
    echo "    Background | Foreground colors"
    echo "---------------------------------------------------------------------"
    for ((bg = 40; bg <= 47; bg++)); do
        for ((bold = 0; bold <= 1; bold++)); do
            echo -en "\033[0m"" ESC[${bg}m   | "
            for ((fg = 30; fg <= 37; fg++)); do
                if [ $bold == "0" ]; then
                    echo -en "\033[${bg}m\033[${fg}m [${fg}m  "
                else
                    echo -en "\033[${bg}m\033[1;${fg}m [1;${fg}m"
                fi
            done
            echo -e "\033[0m"
        done
        echo "--------------------------------------------------------------------- "
    done

    echo
    echo "           Color Code Cheat Sheet "
    echo "           ----------------------------------------------------------"
    echo -e "\t\t Black       0;30\t     Dark Gray     1;30"
    echo -e "\t\t Blue        0;34\t     Light Blue    1;34"
    echo -e "\t\t Green       0;32\t     Light Green   1;32"
    echo -e "\t\t Cyan        0;36\t     Light Cyan    1;36"
    echo -e "\t\t Red         0;31\t     Light Red     1;31"
    echo -e "\t\t Purple      0;35\t     Light Purple  1;35"
    echo -e "\t\t Brown       0;33\t     Yellow        1;33"
    echo -e "\t\t Light Gray  0;37\t     White         1;37"
    echo
    echo
}

function sixteencolors
{
    #
    # This file echoes a bunch of color codes to the terminal to demonstrate
    # what's available. Each line is the color code of one forground color,
    # out of 17 (default + 16 escapes), followed by a test use of that color
    # on all nine background colors (default + 8 escapes).
    #
    T='gYw' # The test text
    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m"
    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m'; do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m"
        done
        echo
    done
    echo
}

# originally taken from iterm2 https://github.com/gnachman/iTerm2/blob/master/tests/24-bit-color.sh
#
#   These functions echo a bunch of 24-bit color codes
#   to the terminal to demonstrate its functionality.
#   The foreground escape sequence is ^[38;2;<r>;<g>;<b>m
#   The background escape sequence is ^[48;2;<r>;<g>;<b>m
#   <r> <g> <b> range from 0 to 255 inclusive.
#   The escape sequence ^[0m returns output to default

function setBackgroundColor
{
    #printf '\x1bPtmux;\x1b\x1b[48;2;%s;%s;%sm' $1 $2 $3
    printf '\x1b[48;2;%s;%s;%sm' $1 $2 $3
}

function resetOutput
{
    echo -en "\x1b[0m\n"
}

# Pick colors in a 256 color terminal
function rainbowColor
{
        local c i j

        printf "Standard 0 to 16 Colors\n"
        for ((c = 0; c < 16; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
        printf "|\n\n"

        printf "Rainbow(ish)17 to 231\n"
        for ((i = j = 0; c < 232; c++, i++)); do
                printf "|"
                ((i > 5 && (i = 0, ++j))) && printf " |"
                ((j > 5 && (j = 0, 1)))   && printf "\b \n|"
                printf "%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
        printf "|\n\n"

        printf "Greyscale Rainbow(ish) 232 to 256\n"
        for (( ; c < 256; c++)); do
                printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
        printf "|\n"

}

function twofivesixcolor()
                           {
    # generates an 8 bit color table (256 colors) for
    # reference purposes, using the \033[48;5;${val}m
    # ANSI CSI+SGR (see "ANSI Code" on Wikipedia)
    #
    echo -en "\n   +  "
    for i in {0..35}; do
        printf "%2b " $i
    done

    printf "\n\n %3b  " 0
    for i in {0..15}; do
        echo -en "\033[48;5;${i}m  \033[m "
    done

    #for i in 16 52 88 124 160 196 232; do
    for i in {0..6}; do
        let "i = i*36 +16"
        printf "\n\n %3b  " $i
        for j in {0..35}; do
            let "val = i+j"
            echo -en "\033[48;5;${val}m  \033[m "
        done
    done

    echo -e "\n"
}

twentyfourcolor()
                  {
    echo
    echo "Currently Not Working"
    echo
}

function spacecolors
{
    f=3 b=4
    for j in f b; do
        for i in {0..7}; do
            printf -v $j$i %b "\e[${!j}${i}m"
        done
    done
    bld=$'\e[1m'
    rst=$'\e[0m'

    cat <<EOF

     $f1  ▀▄   ▄▀     $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4  ▀▄   ▄▀     $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
     $f1 ▄█▀███▀█▄    $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4 ▄█▀███▀█▄    $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
     $f1█▀███████▀█   $f2▀▀███▀▀███▀▀   $f3▀█▀██▀█▀   $f4█▀███████▀█   $f5▀▀███▀▀███▀▀   $f6▀█▀██▀█▀$rst
     $f1▀ ▀▄▄ ▄▄▀ ▀   $f2 ▀█▄ ▀▀ ▄█▀    $f3▀▄    ▄▀   $f4▀ ▀▄▄ ▄▄▀ ▀   $f5 ▀█▄ ▀▀ ▄█▀    $f6▀▄    ▄▀$rst

     $bld$f1▄ ▀▄   ▄▀ ▄   $f2 ▄▄▄████▄▄▄    $f3  ▄██▄     $f4▄ ▀▄   ▄▀ ▄   $f5 ▄▄▄████▄▄▄    $f6  ▄██▄  $rst
     $bld$f1█▄█▀███▀█▄█   $f2███▀▀██▀▀███   $f3▄█▀██▀█▄   $f4█▄█▀███▀█▄█   $f5███▀▀██▀▀███   $f6▄█▀██▀█▄$rst
     $bld$f1▀█████████▀   $f2▀▀▀██▀▀██▀▀▀   $f3▀▀█▀▀█▀▀   $f4▀█████████▀   $f5▀▀▀██▀▀██▀▀▀   $f6▀▀█▀▀█▀▀$rst
     $bld$f1 ▄▀     ▀▄    $f2▄▄▀▀ ▀▀ ▀▀▄▄   $f3▄▀▄▀▀▄▀▄   $f4 ▄▀     ▀▄    $f5▄▄▀▀ ▀▀ ▀▀▄▄   $f6▄▀▄▀▀▄▀▄$rst


                                     $f7▌$rst

                                   $f7▌$rst

                              $f7    ▄█▄    $rst
                              $f7▄█████████▄$rst
                              $f7▀▀▀▀▀▀▀▀▀▀▀$rst

EOF
}

# ANSI Color -- use these variables to easily have different color
#    and format output. Make sure to output the reset sequence after
#    colors (f = foreground, b = background), and use the 'off'
#    feature for anything you turn on.

# note in this first use that switching colors doesn't require a reset
# first - the new color overrides the old one.
function sixcolors
{

    esc=""

    blackf="${esc}[30m"
    redf="${esc}[31m"
    greenf="${esc}[32m"
    yellowf="${esc}[33m" bluef="${esc}[34m"
    purplef="${esc}[35m"
    cyanf="${esc}[36m"
    whitef="${esc}[37m"

    blackb="${esc}[40m"
    redb="${esc}[41m"
    greenb="${esc}[42m"
    yellowb="${esc}[43m" blueb="${esc}[44m"
    purpleb="${esc}[45m"
    cyanb="${esc}[46m"
    whiteb="${esc}[47m"

    boldon="${esc}[1m"
    boldoff="${esc}[22m"
    italicson="${esc}[3m"
    italicsoff="${esc}[23m"
    ulon="${esc}[4m"
    uloff="${esc}[24m"
    invon="${esc}[7m"
    invoff="${esc}[27m"

    reset="${esc}[0m"

    cat <<EOF

     ${redf}▒▒▒▒${reset} ${boldon}${redf}▒▒${reset}   ${greenf}▒▒▒▒${reset} ${boldon}${greenf}▒▒${reset}   ${yellowf}▒▒▒▒${reset} ${boldon}${yellowf}▒▒${reset}   ${bluef}▒▒▒▒${reset} ${boldon}${bluef}▒▒${reset}   ${purplef}▒▒▒▒${reset} ${boldon}${purplef}▒▒${reset}   ${cyanf}▒▒▒▒${reset} ${boldon}${cyanf}▒▒${reset}
     ${redf}▒▒ ■${reset} ${boldon}${redf}▒▒${reset}   ${greenf}▒▒ ■${reset} ${boldon}${greenf}▒▒${reset}   ${yellowf}▒▒ ■${reset} ${boldon}${yellowf}▒▒${reset}   ${bluef}▒▒ ■${reset} ${boldon}${bluef}▒▒${reset}   ${purplef}▒▒ ■${reset} ${boldon}${purplef}▒▒${reset}   ${cyanf}▒▒ ■${reset} ${boldon}${cyanf}▒▒${reset}
     ${redf}▒▒ ${reset}${boldon}${redf}▒▒▒▒${reset}   ${greenf}▒▒ ${reset}${boldon}${greenf}▒▒▒▒${reset}   ${yellowf}▒▒ ${reset}${boldon}${yellowf}▒▒▒▒${reset}   ${bluef}▒▒ ${reset}${boldon}${bluef}▒▒▒▒${reset}   ${purplef}▒▒ ${reset}${boldon}${purplef}▒▒▒▒${reset}   ${cyanf}▒▒ ${reset}${boldon}${cyanf}▒▒▒▒${reset}

EOF
}

function colordna
{
    f=3 b=4
    for j in f b; do
        for i in {0..7}; do
            printf -v $j$i %b "\e[${!j}${i}m"
        done
    done
    bld=$'\e[1m'
    rst=$'\e[0m'
    inv=$'\e[7m'

    cat <<EOF

     ${f1} █-----${bld}█  ${rst}${f2} █-----${bld}█${rst}  ${f3} █-----${bld}█${rst}  ${f4} █-----${bld}█${rst}  ${f5} █-----${bld}█${rst}  ${f6} █-----${bld}█${rst}
      ${f1} █---${bld}█${rst}    ${f2} █---${bld}█${rst}    ${f3} █---${bld}█${rst}    ${f4} █---${bld}█${rst}    ${f5} █---${bld}█${rst}    ${f6} █---${bld}█${rst}
      ${f1}  █-${bld}█${rst}     ${f2}  █-${bld}█${rst}     ${f3}  █-${bld}█${rst}     ${f4}  █-${bld}█${rst}     ${f5}  █-${bld}█${rst}     ${f6}  █-${bld}█${rst}
        ${f1} █${rst}        ${f2} █${rst}        ${f3} █${rst}        ${f4} █${rst}        ${f5} █${rst}        ${f6} █${rst}
       ${f1}${bld} █-${rst}${f1}█${rst}      ${f2}${bld} █_${rst}${f2}█${rst}      ${f3}${bld} █-${rst}${f3}█${rst}      ${f4}${bld} █-${rst}${f4}█${rst}      ${f5}${bld} █-${rst}${f5}█${rst}      ${f6}${bld} █-${rst}${f6}█${rst}
      ${f1}${bld} █---${rst}${f1}█${rst}    ${f2}${bld} █---${rst}${f2}█${rst}    ${f3}${bld} █---${rst}${f3}█${rst}    ${f4}${bld} █---${rst}${f4}█${rst}    ${f5}${bld} █---${rst}${f5}█${rst}    ${f6}${bld} █---${rst}${f6}█${rst}
     ${f1}${bld} █-----${rst}${f1}█${rst}  ${f2}${bld} █-----${rst}${f2}█${rst}  ${f3}${bld} █-----${rst}${f3}█${rst}  ${f4}${bld} █-----${rst}${f4}█${rst}  ${f5}${bld} █-----${rst}${f5}█${rst}  ${f6}${bld} █-----${rst}${f6}█${rst}
      ${f1}${bld} █---${rst}${f1}█${rst}    ${f2}${bld} █---${rst}${f2}█${rst}    ${f3}${bld} █---${rst}${f3}█${rst}    ${f4}${bld} █---${rst}${f4}█${rst}    ${f5}${bld} █---${rst}${f5}█${rst}    ${f6}${bld} █---${rst}${f6}█${rst}
       ${f1}${bld} █-${rst}${f1}█${rst}      ${f2}${bld} █-${rst}${f2}█${rst}      ${f3}${bld} █-${rst}${f3}█${rst}      ${f4}${bld} █-${rst}${f4}█${rst}      ${f5}${bld} █-${rst}${f5}█${rst}      ${f6}${bld} █-${rst}${f6}█${rst}
        ${f1}${bld} █${rst}        ${f2}${bld} █${rst}         ${f3}${bld}█${rst}        ${f4}${bld} █${rst}        ${f5}${bld} █${rst}        ${f6}${bld} █${rst}
       ${f1} █-${bld}█${rst}      ${f2} █-${bld}█${rst}      ${f3} █-${bld}█${rst}      ${f4} █-${bld}█${rst}      ${f5} █-${bld}█${rst}      ${f6} █-${bld}█${rst}
      ${f1} █---${bld}█${rst}    ${f2} █---${bld}█${rst}    ${f3} █---${bld}█${rst}    ${f4} █---${bld}█${rst}    ${f5} █---${bld}█${rst}    ${f6} █---${bld}█${rst}
     ${f1} █-----${bld}█  ${rst}${f2} █-----${bld}█${rst}  ${f3} █-----${bld}█${rst}  ${f4} █-----${bld}█${rst}  ${f5} █-----${bld}█${rst}  ${f6} █-----${bld}█${rst}
      ${f1} █---${bld}█${rst}    ${f2} █---${bld}█${rst}    ${f3} █---${bld}█${rst}    ${f4} █---${bld}█${rst}    ${f5} █---${bld}█${rst}    ${f6} █---${bld}█${rst}
      ${f1}  █-${bld}█${rst}     ${f2}  █-${bld}█${rst}     ${f3}  █-${bld}█${rst}     ${f4}  █-${bld}█${rst}     ${f5}  █-${bld}█${rst}     ${f6}  █-${bld}█${rst}
        ${f1} █${rst}         ${f2}█${rst}        ${f3} █${rst}        ${f4} █${rst}        ${f5} █${rst}        ${f6} █${rst}
       ${f1}${bld} █-${rst}${f1}█${rst}      ${f2}${bld} █_${rst}${f2}█${rst}      ${f3}${bld} █-${rst}${f3}█${rst}      ${f4}${bld} █-${rst}${f4}█${rst}      ${f5}${bld} █-${rst}${f5}█${rst}      ${f6}${bld} █-${rst}${f6}█${rst}
      ${f1}${bld} █---${rst}${f1}█${rst}    ${f2}${bld} █---${rst}${f2}█${rst}    ${f3}${bld} █---${rst}${f3}█${rst}    ${f4}${bld} █---${rst}${f4}█${rst}    ${f5}${bld} █---${rst}${f5}█${rst}    ${f6}${bld} █---${rst}${f6}█${rst}
     ${f1}${bld} █-----${rst}${f1}█${rst}  ${f2}${bld} █-----${rst}${f2}█${rst}  ${f3}${bld} █-----${rst}${f3}█${rst}  ${f4}${bld} █-----${rst}${f4}█${rst}  ${f5}${bld} █-----${rst}${f5}█${rst}  ${f6}${bld} █-----${rst}${f6}█${rst}
      ${f1}${bld} █---${rst}${f1}█${rst}    ${f2}${bld} █---${rst}${f2}█${rst}    ${f3}${bld} █---${rst}${f3}█${rst}    ${f4}${bld} █---${rst}${f4}█${rst}    ${f5}${bld} █---${rst}${f5}█${rst}    ${f6}${bld} █---${rst}${f6}█${rst}
       ${f1}${bld} █-${rst}${f1}█${rst}      ${f2}${bld} █-${rst}${f2}█${rst}      ${f3}${bld} █-${rst}${f3}█${rst}      ${f4}${bld} █-${rst}${f4}█${rst}      ${f5}${bld} █-${rst}${f5}█${rst}      ${f6}${bld} █-${rst}${f6}█${rst}
        ${f1}${bld} █${rst}        ${f2}${bld} █${rst}        ${f3}${bld} █${rst}        ${f4}${bld} █${rst}        ${f5}${bld} █${rst}        ${f6}${bld} █${rst}
       ${f1} █-${bld}█${rst}      ${f2} █-${bld}█${rst}      ${f3} █-${bld}█${rst}      ${f4} █-${bld}█${rst}      ${f5} █-${bld}█${rst}      ${f6} █-${bld}█${rst}
      ${f1} █---${bld}█${rst}    ${f2} █---${bld}█${rst}    ${f3} █---${bld}█${rst}    ${f4} █---${bld}█${rst}    ${f5} █---${bld}█${rst}    ${f6} █---${bld}█${rst}
     ${f1} █-----${bld}█  ${rst}${f2} █-----${bld}█${rst}  ${f3} █-----${bld}█${rst}  ${f4} █-----${bld}█${rst}  ${f5} █-----${bld}█${rst}  ${f6} █-----${bld}█${rst}

EOF
}

function ghostColors
                     {
    f=3
    b=4
    for j in f b; do
        for i in {0..7}; do
            printf -v $j$i %b "\e[${!j}${i}m"
        done
    done
    bld=$'\e[1m'
    rst=$'\e[0m'
    inv=$'\e[7m'
    cat <<EOF

$f1    ▄▄▄      $f2    ▄▄▄      $f3    ▄▄▄      $f4    ▄▄▄      $f5    ▄▄▄      $f6    ▄▄▄
$f1   ▀█▀██  ▄  $f2   ▀█▀██  ▄  $f3   ▀█▀██  ▄  $f4   ▀█▀██  ▄  $f5   ▀█▀██  ▄  $f6   ▀█▀██  ▄
$f1 ▀▄██████▀   $f2 ▀▄██████▀   $f3 ▀▄██████▀   $f4 ▀▄██████▀   $f5 ▀▄██████▀   $f6 ▀▄██████▀
$f1    ▀█████   $f2    ▀█████   $f3    ▀█████   $f4    ▀█████   $f5    ▀█████   $f6    ▀█████
$f1       ▀▀▀▀▄ $f2       ▀▀▀▀▄ $f3       ▀▀▀▀▄ $f4       ▀▀▀▀▄ $f5       ▀▀▀▀▄ $f6       ▀▀▀▀▄
$bld
$f1    ▄▄▄      $f2    ▄▄▄      $f3    ▄▄▄      $f4    ▄▄▄      $f5    ▄▄▄      $f6    ▄▄▄
$f1   ▀█▀██  ▄  $f2   ▀█▀██  ▄  $f3   ▀█▀██  ▄  $f4   ▀█▀██  ▄  $f5   ▀█▀██  ▄  $f6   ▀█▀██  ▄
$f1 ▀▄██████▀   $f2 ▀▄██████▀   $f3 ▀▄██████▀   $f4 ▀▄██████▀   $f5 ▀▄██████▀   $f6 ▀▄██████▀
$f1    ▀█████   $f2    ▀█████   $f3    ▀█████   $f4    ▀█████   $f5    ▀█████   $f6    ▀█████
$f1       ▀▀▀▀▄ $f2       ▀▀▀▀▄ $f3       ▀▀▀▀▄ $f4       ▀▀▀▀▄ $f5       ▀▀▀▀▄ $f6       ▀▀▀▀▄
$rst
EOF
}

function show_help
{
    grep '^#/' "${BASH_SOURCE[0]}" | cut -c4- ||
        die "Failed to display usage information"
}

function theBRAIN
{

    case "$1" in
        1) sixteencolors ;;
        2) colortable ;;
        3) twentyfourcolor ;;
        4) theTwoFiveSix ;;
        5) rainbowColor ;;
        6) spacecolors ;;
        7) sixcolors ;;
        8) colordna ;;
        9) ghostColors ;;
        -h | --help)
            show_help
            exit
            ;;
        *) show_help ;;
    esac
}

theBRAIN "$@"

exit 1
