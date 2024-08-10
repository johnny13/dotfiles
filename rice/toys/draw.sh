#!/bin/bash
#Background Colors
E=$(tput sgr0);    R=$(tput setab 1); G=$(tput setab 2); Y=$(tput setab 3);
B=$(tput setab 4); M=$(tput setab 5); C=$(tput setab 6); W=$(tput setab 7);
function e() { echo -e "$E"; }
function x() { echo -n "$E  "; }
function r() { echo -n "$R  "; }
function g() { echo -n "$G  "; }
function y() { echo -n "$Y  "; }
function b() { echo -n "$B  "; }
function m() { echo -n "$M  "; }
function c() { echo -n "$C  "; }
function w() { echo -n "$W  "; }

#putpixels
function u() { 
    h="$*";o=${h:0:1};v=${h:1}; 
    for i in `seq $v` 
    do 
        $o;
    done 
}

img="\
x21 r1 b1 r1 x3 b2 x1 r2 x8 e1 x13 b2 x2 b1 x1 r1 b1 x2 r1 x2 r2 x3 r1 x8 e1 x12 b1 x4 r1 x5 r1 x6 b1 x9 e1 x22 r1 x7 r2 x8 e1 x10 b1 x7 r1 x1 r1 x1 r1 b1 x5 r1 x1 b1 x8 e1 x2 b2 x8 r1 x1 b1 x6 r1 x5 r1 x12 e1 b2 x1 b3 x3 b1 x5 r1 x4 r1 x8 r1 x3 b1 x6 e1 x5 b1 x2 b1 r1 x3 b1 x19 b1 x6 e1 b1 x5 b2 r1 x2 r1 b1 x4 r1 x2 b5 x2 r1 x4 b2 x6 e1 b1 x6 b1 r1 x7 r1 x1 b3 x1 r1 x6 b1 x1 b1 x8 e1 x3 b1 x1 r3 x4 b1 x1 r1 b1 x1 b1 x4 b1 x1 b2 x1 b1 x12 e1 x5 r1 x1 b2 x2 b1 x6 r1 x7 r1 x8 r2 x3 e1 x6 b1 x3 b1 x12 b1 x1 b1 x6 r3 x5 e1 x6 b1 x1 b1 x1 r1 x29 e1 x8 r1 x1 b1 x3 r1 x15 r1 x9 e1 x6 b3 x1 b1 x18 r1 b1 x9 e1 x5 r1 x1 b2 x14 r1 x1 b1 x1 r1 x12 e1 x9 r1 x12 b1 r1 x5 b1 x10 e1 x6 r1 x5 b1 x9 r2 x1 b1 x1 b1 x12 e1 x2 r2 x1 r1 x7 b1 x7 r2 x1 b1 x1 b1 x13 e1 x2 r1 x11 b1 x5 b1 x3 b1 x15 e1 x17 b3 x20 e1 x40"

for n in $img
do
    u $n
done
e;
exit 0;
