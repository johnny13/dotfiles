# ❬❮❰ Research Chemicals ❱❯❭

This folder contains all the code needed

1. `.dotfiles` synchronization & `.bashrc` generation
2. manage and create new `<shell>.sh` scripts
3. ??? `TBD` random CLI mischief
4. create and display various `ascii` artwork
5. bootstrap a clean Debian Linux or MacOS box into a sexy `DEVELOPER` environment

The directory structure has been broken down into easy to use sections. Hopefully this format may be of help to others.

Mostly its just to remind myself what is going on in my clandestine laboratory.

## ▸ Sections

Here is an overview of the major sections

1. **core**  #❱ contains dotfiles and shell scripts used across all machines
2. **local** #❱ dotfiles and shell scripts for specific machines based on hostname
3. **media** #❱ ascii artwork and color toys
4. **new**   #❱ templates for new shell scripts

The remaining directories are as follows:

1. **_lab**  #❱ this folder contains the scripts required to run the main `menu.sh` script.
2. **vault** #❱ a cache directory for backing up and changed dotfiles before they are overwritten.

------------------------

### • core

This section contains all the default scripts and code bits that you want on all your machines.

```sh
    ◼ copy #❱ dotfiles copied into $HOME
    ◼ link #❱ dotfiles symlinked into $HOME
    ◼ rc   #❱ files used to generate a .bashrc file
    ◼ sh   #❱ shell scripts and cli apps
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

------------------------

### • new

```
new
 ├── [Jan 07 01:36]  NODE
 │   ├── [Dec 16 03:04]  _library
 │   ├── [Nov 24 07:03]  ervy
 │   │   ├── [Nov 24 07:03]  demo
 │   │   ├── [Nov 24 07:03]  lib
 │   │   └── [Nov 24 07:03]  site
 │   │       ├── [Nov 24 07:03]  imgs
 │   │       ├── [Nov 24 07:03]  js
 │   ├── [Dec 16 03:03]  prompt
 │   └── [Dec 16 03:02]  tui
 ├── [Dec 16 03:02]  PHP
 │   ├── [Dec 16 03:01]  _library
 │   ├── [Dec 16 03:02]  menu
 │   ├── [Dec 16 03:01]  simple
 │   │   └── [Dec 16 03:01]  php-cli
 │   │       ├── [Dec 16 03:01]  examples
 │   │       ├── [Dec 16 03:01]  src
 │   │       └── [Dec 16 03:01]  tests
 │   └── [Dec 16 03:01]  zero
 └── [Jan 07 01:36]  SHELL
     ├── [Dec 02 07:32]  ansi
     │   ├── [Dec 02 07:32]  examples
     │   └── [Dec 02 07:32]  images
     ├── [Nov 17 06:26]  bashly
     ├── [Aug 13 06:51]  freshbash
     │   ├── [Aug 13 03:59]  Libs
     │   │   └── [Aug 13 03:59]  libui-sh
32 directories, 84 files (1.55 MB)
```

This directory contains everything to generate a new `CLI` script. This can be done in one of three languages:

1. **PHP**
2. **NODE.js**
3. **BASH**

------------------------

### • media

```
 media/
 ├── [Jan 08 09:47]  ascii
 ├── [Nov 14 07:30]  icons
 ├── [Jan 22 09:19]  toys
 └── [Jan 22 09:18]  walls
4 directories, 130 files (542 kB)
```

ascii artwork, wallpapers, icons used for notifications and whatnot. color tools are also found within.

------------------------

### • _lab_

scripts and files used to generate the menu, and run the entirety of `Research Chemicals`.

------------------------

#### NOTES, EXTRAS & INSPIRATION

[https://github.com/cowboy/dotfiles](https://github.com/cowboy/dotfiles) dotfile examples

[https://github.com/DannyBen/bashly](https://github.com/DannyBen/bashly)

Tool to Bootstrap a new machine [https://github.com/anishathalye/dotbot](https://github.com/anishathalye/dotbot)

Tool to manage installed packages across systems [https://github.com/tversteeg/emplace](https://github.com/tversteeg/emplace)
