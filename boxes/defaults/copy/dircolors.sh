# Configuration file for dircolors, a utility to help you set the
# LS_COLORS environment variable used by GNU ls with the --color option.

# Copyright (C) 1996, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006
# Free Software Foundation, Inc.
# Copying and distribution of this file, with or without modification,
# are permitted provided the copyright notice and this notice are preserved.
#
# You can copy this file to .dir_colors in your $HOME directory to override
# the system defaults.

# Below, there should be one TERM entry for each termtype that is colorizable
TERM Eterm
TERM ansi
TERM color-xterm
TERM con132x25
TERM con132x30
TERM con132x43
TERM con132x60
TERM con80x25
TERM con80x28
TERM con80x30
TERM con80x43
TERM con80x50
TERM con80x60
TERM console
TERM cygwin
TERM dtterm
TERM gnome
TERM konsole
TERM kterm
TERM linux
TERM linux-c
TERM mach-color
TERM mlterm
TERM putty
TERM putty-256color
TERM rxvt
TERM rxvt-cygwin
TERM rxvt-cygwin-native
TERM rxvt-unicode
TERM screen
TERM screen-256color
TERM screen-bce
TERM screen-w
TERM screen.linux
TERM vt100
TERM xterm
TERM xterm-256color
TERM xterm-color
TERM xterm-debian

# Special files

# Below are the color init strings for the basic file types. A color init
# string consists of one or more of the following numeric codes:
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
NORMAL                  00;37       # global default
FILE                    01;34       # normal file
RESET                   00;37       # reset to "normal" color
DIR                     00;34       # directory
LINK                    00;36       # symbolic link. (If you set this to 'target' instead of a
                                    # numerical value, the color is as for the file pointed to.)
MULTIHARDLINK           00;37       # regular file with more than one link
FIFO                    40;33       # pipe
SOCK                    00;35       # socket
DOOR                    00;35       # door
BLK                     40;33;01    # block device driver
CHR                     40;33;01    # character device driver
ORPHAN                  00;05;37;41 # orphaned syminks
MISSING                 00;05;37;41 # ... and the files they point to
SETUID                  37;41       # file that is setuid (u+s)
SETGID                  30;43       # file that is setgid (g+s)
CAPABILITY              30;41       # file with capability
STICKY_OTHER_WRITABLE   30;42       # dir that is sticky and other-writable (+t,o+w)
OTHER_WRITABLE          04;34       # dir that is other-writable (o+w) and not sticky
STICKY                  37;44       # dir with the sticky bit set (+t) and not other-writable
EXEC                    00;32       # This is for files with execute permission:

# If you use DOS-style suffixes, you may want to uncomment the following:
.cmd 00;33 # executables (bright green)
.exe 00;33
.com 00;33
.btm 00;33
.bat 00;33


## archive files
.7z     01;31
.Z      01;31
.ace    01;31
.alz    01;31
.apk    01;31
.arc    01;31
.arj    01;31
.b1     01;31
.bz     01;31
.bz2    01;31
.bzip2  01;31
.cab    01;31
.cfs    01;31
.cpio   01;31
.deb    01;31
.udeb   01;31
.dar    01;31
.dmg    01;31
.dz     01;31
.ear    01;31
.jar    01;31
.war    01;31
.gem    01;31
.gz     01;31
.ha     01;31
.iso    01;31
.lz     01;31
.lzh    01;31
.lzo    01;31
.lzma   01;31
.pea    01;31
.rar    01;31
.rpm    01;31
.rz     01;31
.s7z    01;31
.tar    01;31
.taz    01;31
.tbz    01;31
.tbz2   01;31
.tgz    01;31
.tlz    01;31
.txz    01;31
.tz     01;31
.xz     01;31
.z      01;31
.zip    01;31
.zoo    01;31

## audio formats
.aa    01;36
.aax   01;36
.aac   01;36
.aiff  01;36
.ape   01;36
.au    01;36
.axa   01;36
.dvf   01;36
.flac  01;36
.gsm   01;36
.m4a   01;36
.m4b   01;36
.m4p   01;36
.mid   01;36
.midi  01;36
.mka   01;36
.mp3   01;36
.mpc   01;36
.oga   01;36
.ogg   01;36
.opus  01;36
.ra    01;36
.spx   01;36
.wav   01;36
.wma   01;36
.xspf  01;36

## Binary files
.aux         01;30
.bak         01;30
.bbl         01;30
.blg         01;30
.lof         01;30
.log         01;30
.lol         01;30
.lot         01;30
.out         01;30
.toc         01;30
*~           01;30
*#           01;30
.part        01;30
.incomplete  01;30
.swp         01;30
.tmp         01;30
.temp        01;30
.o           01;30
.obj         01;30
.pyc         01;30
.pyo         01;30
.class       01;30
.cache       01;30
.egg-info    01;30

## source code files
.bat        00;33
.H          00;33
.c++        00;33
.cc         00;33
.cpp        00;33
.cs         00;33
.cxx        00;33
.h++        00;33
.hh         00;33
.hxx        00;33
.hpp        00;33
.c          00;33
.h          00;33
.clj        00;33
.cljs       00;33
.cbl        00;33
.cob        00;33
.coffee     00;33
.litcoffee  00;33
.ex         00;33
.exs        00;33
.erl        00;33
.hrl        00;33
.gs         00;33
.dot        00;33
.env        00;33
.fs         00;33
.fsx        00;33
.go         00;33
.groovy     00;33
.hs         00;33
.lhs        00;33
.java       00;33
.js         00;33
.jsx        00;33
.es         00;33
.ts         00;33
.jl         00;33
.kt         00;33
.kts        00;33
.lisp       00;33
.lsp        00;33
.lua        00;33
.m          00;33
.mm         00;33
.C          00;33
.ml         00;33
.mli        00;33
.pp         00;33
.pas        00;33
.inc        00;33
.pl         00;33
.p6         00;33
.pl6        00;33
.pm6        00;33
.php        00;33
.php5       00;33
.P          00;33
.pro        00;33
.py         00;33
.R          00;33
.RData      00;33
.r          00;33
.rda        00;33
.rds        00;33
.rkt        00;33
.erb        00;33
.rb         00;33
.rs         00;33
.rlib       00;33
.scala      00;33
.sc         00;33
.scm        00;33
.ss         00;33
.bash       00;33
.sh         00;33
.csh        00;33
.fish       00;33
.ksh        00;33
.tcsh       00;33
.zsh        00;33
.swift      00;33
.tcl        00;33
.tbc        00;33
.T          00;33
.t          00;33
.tu         00;33
.zcml       00;33

## config files
.conf        00;36
.config      00;36
.cnf         00;36
.cfg         00;36
.ini         00;36
.properties  00;36
.yaml        00;36
.vcl         00;36

## Data / database
.accdb   00;32
.accde   00;32
.accdr   00;32
.db      00;32
.json    00;32
.mdb     00;32
.plist   00;32
.sql     00;32
.sqlite  00;32
.xml     00;32

## document files
.css    00;32
.diff   00;32
.htm    00;32
.html   00;32
.md     00;32
.patch  00;32
.pdf    00;32
.PDF    00;32
.ps     00;32
.rst    00;32
.txt    00;32
.tex    00;32
.doc    00;32
.docx   00;32
.ppt    00;32
.pptx   00;32
.xls    00;32
.xlsx   00;32
.key    00;32
.ods    00;32
.odt    00;32
.odp    00;32

## image formats
.CR2   00;35
.JPG   00;35
.bmp   00;35
.cgm   00;35
.dl    00;35
.emf   00;35
.eps   00;35
.gif   00;35
.ico   00;35
.jpeg  00;35
.jpg   00;35
.mng   00;35
.pbm   00;35
.pcx   00;35
.pgm   00;35
.png   00;35
.ppm   00;35
.svg   00;35
.svgz  00;35
.tga   00;35
.tif   00;35
.tiff  00;35
.xbm   00;35
.xcf   00;35
.xpm   00;35
.xwd   00;35
.yuv   00;35

## Files of special interest
.rdf              01;37
.owl              01;37
.n3               01;37
.ttl              01;37
.nt               01;37
.torrent          01;37
*build.xml        01;37
*rc               01;37
.nfo              01;37
*README           01;37
*README.txt       01;37
*readme.txt       01;37
*README.markdown  01;37
*README.md        01;37
*LICENSE          01;37
*COPYING          01;37
*INSTALL          01;37
*COPYRIGHT        01;37
*AUTHORS          01;37
*CONTRIBUTORS     01;37
*PATENTS          01;37
*VERSION          01;37
*NOTICE           01;37
*CHANGES          01;37

## video formats
.3g2   01;36
.3gp   01;36
.anx   01;36
.asf   01;36
.axv   01;36
.avi   01;36
.divx  01;36
.flc   01;36
.fli   01;36
.f4a   01;36
.f4b   01;36
.f4p   01;36
.f4v   01;36
.flv   01;36
.gl    01;36
.m2ts  01;36
.m2v   01;36
.m4v   01;36
.mkv   01;36
.mov   01;36
.mp2   01;36
.mp4   01;36
.mp4v  01;36
.mpe   01;36
.mpeg  01;36
.mpg   01;36
.mpv   01;36
.nuv   01;36
.ogm   01;36
.ogv   01;36
.ogx   01;36
.qt    01;36
.rm    01;36
.rmvb  01;36
.vob   01;36
.webm  01;36
.wmv   01;36
