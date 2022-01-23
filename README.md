# ❬❮❰ Research Chemicals ❱❯❭

This folder contains all the code needed

1. to setup and maintain my `.dotfiles`
2. manage and create `bash` scripts
3.
4. create and display `ascii` artwork
5. bootstrap a clean OS into a DEV environment

The directory structure has been broken down into easy to use sections. Hopefully this format may be of help to others.

## ▸ Sections

Here is an overview of the major sections

------------------------

### • core

This section contains all the default scripts and code bits that you want on all your machines.

```sh
    ◼ aliases #❱ .bash_alias shortcuts & snippets
    ◼ configs #❱ default dotfiles used when bootstrapping a n ew machine
    ◼ profile #❱ .bashrc, .bash_functions, shell colors etc.
    ◼ scripts #❱ help shell scripts and cli apps or almost apps
```

------------------------

#### ⬦ local

local is a subset of the core folder. It contains things that are unique to the machine. So you can easily have machine specific customizations added onto of the standard `dotfiles`.

So the directory structure goes like this:

```sh
   ┏━❪ local ❫
   ┗━━┳━▶ machine_one
      ╚══╗ ⬩ aliases
         ║ ⬩ private
         ║ ⬩ profile
     ╔═══╝ ⬩ scripts
     ┗┳━▶ machine_two
      ╚══╗ ⬩ aliases
         ║ ⬩ private
         ║ ⬩ profile
     ╔═══╝ ⬩ scripts
     ┗━━▶ etc
```

This way each machine can still be version controlled and accessed from one repository.

------------------------

### • tools

Here are various helpful scripts for setting up and maintaining a dev environment. Things like generating color profiles, creating new scripts etc.

---------------------------------------------------------------------------

### • media

ascii artwork, and icons used for notifications and whatnot. some sound snippets. pretty basic stuff.


# FRAMEWORK OPTIONS

[https://github.com/DannyBen/bashly](https://github.com/DannyBen/bashly)

Tool to Bootstrap a new machine [https://github.com/anishathalye/dotbot](https://github.com/anishathalye/dotbot)

Tool to manage installed packages across systems [https://github.com/tversteeg/emplace](https://github.com/tversteeg/emplace)
