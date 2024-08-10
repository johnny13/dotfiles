```shell

     ..                            .;,                      .'ckKo.
    .x0c               ,,.        .dWK;                 .'codkXNk.
    .xW0'        ....'.XNk'       .OWNx.           ..;lodoc,.,kx'
 .,,'oNNd;:clodxkkkk0XXOWN0;      :XNW0,'c:'.',;cldOXOc'.     .
 :OK0KNWXOxdlc:,'...oNXoNNNK:   .cONXNXccXNXOxdol;c0Wo
  ...,OWK:         ,0Wx;KNNNKc .dNNOo0Wd.,dkl.    .OWo
      oNNl        'ONx..xNK0NXloXWX:.xWO'         ,KN:
      ;XWx.      ;0Nd.  cNKldNNNNXo  cNX:         :N0'
      .OW0'    .lKKl.   '0Nl.oKKd:.  ,0Wd.        dWx.
      .dWX:   ,kXk'     .xWx. ..     .xW0'       .kWo
       cXWd.,xKO;       .dW0,         cNNc       .ONl
       ,0WKO0x;.      kX00NX;         'OWk.      .kWo
 ;xkdllxXWNx.         .l0NNX:          oNXc       cNO.
 ,xO0Oxoll;.            .d0d.          '0WO'      .c0c
   ..                     .             ,ol'        .'

   •• ━━━━━ • ━━━━━━━━━━━━ •• ━━━ • ━━━━━━━ ••• ━━━━━ ••
   D O T F I L E    M A N A G E M E N T    T O O L K I T

```

# ❬❮❰ DOTFILE MANAGEMENT TOOLKIT ❱❯❭

This codebase can be used to setup & maintain UNIX shell environments. It provides a number of new/improved functions and features.
There are a number of different areas that correspond to different use cases, for instant, part of the functionality deals with setting up a new machine, installing packages from a list, and setting up various CLI tools.
While another area is focused on script templates, and asssiting in the creation of new shell commands. Here is a quick overview of the various sections.

1. dotfile synchronization
2. manage and create new `<shell>.sh` scripts
3. create and display various `ascii` artwork
4. bootstrap a machine into a sexy `DEV` environment
5. Backup installed packages & programs

A lot of this is simply a log of my trials and tribulations using and building out my clandestine digital laboratory.

Mileage may very, results not guaranteed. Use at your own risk, and wash your hands before returning to work.

## ▸ Sections

Here is an overview of the major sections

1. **core**  ❱ contains dotfiles and shell scripts used across all machines
2. **local** ❱ dotfiles and shell scripts for specific machines based on hostname
3. **media** ❱ ascii artwork and color toys
4. **new**   ❱ templates for new shell scripts

The remaining directories are as follows:

1. **_lab**  ❱ this folder contains the scripts required to run the main `menu.sh` script.
2. **vault** ❱ a cache directory for backing up and changed dotfiles before they are overwritten.

------------------------

### • core

This section contains all the default scripts and code bits that you want on all your machines.

```sh
    ◼ copy ❱ dotfiles copied into $HOME
    ◼ link ❱ dotfiles symlinked into $HOME
    ◼ rc   ❱ files used to generate a .bashrc file
    ◼ sh   ❱ shell scripts and cli apps
```

------------------------

### ⬦ local

local is a subset of the core folder. It contains things that are unique to the machine. So you can easily have machine specific customizations added onto the core set of `dotfiles` and shell scripts.

So the directory structure goes like this:

```sh
   ┏━❪ local ❫
   ┗━━┳━▶ machine_one
      ╚══╗ ⬩ copy
         ║ ⬩ link
         ║ ⬩ rc
     ╔═══╝ ⬩ sh
     ┗┳━▶ machine_two
      ╚══╗ ⬩ copy
         ║ ⬩ link
         ║ ⬩ rc
     ╔═══╝ ⬩ sh
     ┗━━▶ etc
```

This way each machine can still be version controlled and accessed from one repository.

------------------------

### • box

Here are various helpful scripts for setting up and maintaining a dev environment. Things like generating color profiles, creating new scripts etc.

#### INSTALL

Debian install instructions are listed below. These functions will grab the most recent copy of the file in `box/Debian/RUN.sh` or `box/Darwin/RUN.sh` depending on which platform is requested. For the Darwin instructions, simply swap out debian for darwin in the URL.

```shell

  $  wget -O RUN.sh https://huement.tiny.us/debian
  $  chmod +x ./RUN.sh
  $  ./RUN.sh

```

------------------------

### • new

```
new
├── NODE
│   ├── _library
│   ├── ervy
│   │   ├── LICENSE
│   │   ├── README.md
│   │   ├── demo
│   │   ├── index.js
│   │   ├── lib
│   │   ├── package.json
│   │   └── site
│   ├── prompt
│   └── tui
├── PHP
│   ├── _library
│   ├── menu
│   ├── simple
│   │   └── php-cli
│   └── zero
└── SHELL
    ├── ansi
    │   ├── CHANGELOG.md
    │   ├── CONTRIBUTING.md
    │   ├── LICENSE.md
    │   ├── README.md
    │   ├── ansi
    │   ├── bpm.ini
    │   ├── examples
    │   └── images
    ├── auto-sized-fzf.sh
    ├── bashly
    │   └── bashly.yml
    ├── dialog.sh
    ├── freshbash
    │   ├── Libs
    │   ├── README.md
    │   ├── build.sh
    │   └── fresh.txt
    ├── help_header.sh
    ├── menu_select_opt.sh
    └── scriptTemplate.sh

21 directories, 19 files (1.55 MB)
```

This directory contains everything to generate a new `CLI` script. This can be done in one of three languages:

1. **PHP**
2. **NODE.js**
3. **BASH**

------------------------

### • media

```
 media/
 ├── ascii
 ├── icons
 ├── toys
 └── walls

4 directories, 130 files (542 kB)
```

ascii artwork, wallpapers, icons used for notifications and whatnot. color tools are also found within.

------------------------

## NOTES & EXTRAS

The following sections are less important and highlight the remaining non critical folders and provide a bit more context and history.

### • _lab & vault

scripts and files used to generate the menu, and run the entirety of `Research Chemicals` are found in the **_lab** folder, while **vault** serves as a cache / backup folder.

------------------------

### INSPIRATION

[https://github.com/cowboy/dotfiles](https://github.com/cowboy/dotfiles) dotfile examples

[https://github.com/DannyBen/bashly](https://github.com/DannyBen/bashly)

Tool to Bootstrap a new machine [https://github.com/anishathalye/dotbot](https://github.com/anishathalye/dotbot)

Tool to manage installed packages across systems [https://github.com/tversteeg/emplace](https://github.com/tversteeg/emplace)
