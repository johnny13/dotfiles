```shell
	┳━┓┏━┓┏┓┓┳━┓o┳  ┳━┓  ┏┏┓┏━┓┏┏┓┏┓┓
	┃ ┃┃ ┃ ┃ ┣━ ┃┃  ┣━   ┃┃┃┃ ┳┃┃┃ ┃
	┇━┛┛━┛ ┇ ┇  ┇┇━┛┻━┛  ┛ ┇┇━┛┛ ┇ ┇
	•• ━━━━━ • ━━━━━━━━━━━ •• ━━━ • ━
	C O M M A N D  L I N E  T O O L S
```

This repo \*attempts\* to handle all my dotfiles across my different machines. It relies on GNU Stow to symlink everything from the `dotfiles/$user` directory to the standard `$HOME` folder. 

BUT WAIT! THERES MORE! This repo slices, it dices, and it rices your desktop. If thats not enough, there are plenty of shell scripts (sorted via OS and/or interpreter), and then, last but not least, are the dev box setup scripts that take a clean install MacOS or Debian install, and make it a worthwhile development machine. 


# SECTIONS

```sh
    ◼ dotfiles ❱ config files used across all machines
    ◼ rice     ❱ ascii-art and other nonsense
    ◼ scripts  ❱ macos and debian bash shell scripts
    ◼ setup    ❱ quickly build out a dev box
```

Most of the directories are very straightforward and require little in the way of explination. The one thing that isnt 100% obvious is the awesome **command line interface** that powers this repo. 

### CLI SCRIPT

Simply run script like so: `$ ./RUN.sh` from your favorite terminal and you'll be greated with the main menu...

![Alt text](.run/demo.png?raw=true "CLI Example")

## • dotfiles •

This section contains all the default scripts and code bits that you want on all your machines.

```sh
    ◼ eris    ❱
    ◼ fortune ❱
    ◼ zshrc   ❱
```

There are two ways of setting up a machine. Either they have **ONE** Root package, that contains files and/or folders, and all that is **stowed** under their $HOME, or they have **MULTIPLE** folders that all get **stowed** to their $HOME.

`eris` uses **one** root folder.

`fortune` uses **multiple** folders (fortune & zshrc).

Either way is acceptable. Whatever you choose, you must make a `config-$user.sh` file that contains whatever format you decide on. 

------------------------

### ⬦ rice
------------------------

### • scripts

------------------------

### • setup

------------------------

## CHANGELOG ❯❯ ❯  ❯

+ Aug 14 2024 | added the Eris machines's dotfiles