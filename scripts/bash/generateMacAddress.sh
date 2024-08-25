#!/bin/bash
RANGE=255
#set integer ceiling

number=$RANDOM
numbera=$RANDOM
numberb=$RANDOM
#generate random numbers

let "number %= $RANGE"
let "numbera %= $RANGE"
let "numberb %= $RANGE"
#ensure they are less than ceiling

octets='00-60-E4'
octets_colon='00:60:E4'
# COMPUSERVE, INC. https://gist.github.com/aallan/b4bb86db86079509e6159810ae9bd3e4

octeta=`echo "obase=16;$number" | bc`
octetb=`echo "obase=16;$numbera" | bc`
octetc=`echo "obase=16;$numberb" | bc`
#use a command line tool to change int to hex(bc is pretty standard)
#they're not really octets.  just sections.

macadd_dash="${octets}-${octeta}-${octetb}-${octetc}"
macadd_colon="${octets_colon}:${octeta}:${octetb}:${octetc}"
#concatenate values and add dashes

echo $macadd_dash
echo $macadd_colon
#echo result to screen
