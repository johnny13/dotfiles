## HailEris

The best way to setup a new MacOS **GOLDEN APPLE** development environment. This codebase uses Dorthy to handle the Dotfiles, as well as a bunch of other shell tweaks & goodies.

There is a couple of things we will need to do first, install Xcode Tools, install homebrew, and either install git and clone the repo, or download the repo locally and unpack it. To get started run the following commands

```shell
  $ xcode-select install
```

Then install Homebrew

```shell
  $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then get this repo in one of the two ways

```sass
  # Git Method
  brew install git
  git clone https://github.com/johnny13/dotfiles
```

Or simply go here and download as zip and upack: [https://github.com/johnny13/dotfiles](https://github.com/johnny13/dotfiles)


### Run Brewfile

Now that you have the requirements met, assuming you unpacked the repo to `~/Developer/dotfiles` you can run the following:

```shell
  $ cd ~/Developer/dotfiles 
  $ brew bundle install 
```

This will take a while to complete, and when it is done, you will have all the required Apps & Packages that are required for MacOS Web Development, Shell Scripting, and other various programming related items


## • Folder

TODO: The folder structure needs to detailed here

1. **bin** ❱ command line scripts
2. **dist** ❱ finalized output
3. **public** ❱ static files

> NOTES:
> • Anything that needs to be noted goes here

---

### • Code Function

TODO: This might be needed to explain how a function works or whatever

```sh
   ━━❪ public ❫
   ━━━▶ demo
   ━━━▶ favicon
   ━━━▶ fonts
```

---

### • TBD
