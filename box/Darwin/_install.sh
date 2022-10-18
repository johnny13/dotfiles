xcode-select --install

# Homebrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor

#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#echo "options vfio-pci ids=8086:9d2f,10de:0fb9 disable_vga=1" > /etc/modprobe.d/vfio.conf

# Install some stuff before others!
important_casks=(
    authy
    google-chrome
    hyper
    jetbrains-toolbox
    stats
    visual-studio-code
    slack
)

brews=(
    ##### Install these first ######
    awscli
    git
    jabba
    python3
    scala
    ################################
    "bash-snippets --without-all-tools --with-cryptocurrency --with-stocks --with-weather"
    bat
    #cheat         # https://github.com/cheat/cheat
    coreutils
    dfc         # https://github.com/rolinh/dfc
    exa         # https://the.exa.website/
    findutils
    "fontconfig --universal"
    git-extras  # for git undo
    git-lfs
    "gnuplot --with-qt"
    "gnu-sed --with-default-names"
    go
    gpg
    #hosts
    hstr        # https://github.com/dvorka/hstr
    htop        # https://htop.dev/
    httpie      # https://httpie.io/
    iftop       # https://www.ex-parrot.com/~pdw/iftop/
    "imagemagick --with-webp"
    lnav        # https://lnav.org/
    m-cli       # https://github.com/rgcr/m-cli
    macvim      # https://macvim-dev.github.io/macvim/
    micro       # https://github.com/zyedidia/micro
    mtr         # https://www.bitwizard.nl/mtr/
    neofetch    # https://github.com/dylanaraps/neofetch
    node
    poppler     # https://poppler.freedesktop.org/
    postgresql
    pgcli
    pv          # https://www.ivarch.com/programs/pv.shtml
    python
    osquery
    ruby
    shellcheck  # https://www.shellcheck.net/
    tmux
    tree
    trash
    "vim --with-override-system-vi"
    "wget --with-iri"
    xsv
    youtube-dl
)

casks=(
    aerial
    adobe-acrobat-pro
    barrier
    cakebrew
    cleanmymac
    docker
    firefox
    google-backup-and-sync
    github
    handbrake
    iina
    istat-server
    kap
    launchrocket
    macdown
    monitorcontrol
    qlcolorcode
    qlmarkdown
    qlstephen
    quicklook-json
    quicklook-csv
    satellite-eyes
    sidekick
    sloth
    soundsource
    transmission
    xquartz
)

pips=(
    pip
    glances
    ohmu
    pythonpy
)

gems=(
    bundler
)

npms=(
    dart-sass
    grunt
    gulp
    gitjk
    n         # https://github.com/tj/n
)

git_email='derek@huement.com'
git_configs=(
    "branch.autoSetupRebase always"
    "color.ui auto"
    "core.autocrlf input"
    "credential.helper osxkeychain"
    "merge.ff false"
    "pull.rebase true"
    "push.default simple"
    "rebase.autostash true"
    "rerere.autoUpdate true"
    "remote.origin.prune true"
    "rerere.enabled true"
    "user.name derekscott"
    "user.email ${git_email}"
)

fonts=(
    font-fira-code
    font-source-code-pro
)

JDK_VERSION=amazon-corretto@1.8.222-10.1

########################################

set +e
set -x

function prompt
{
    if [[ -z "${CI}" ]]; then
        read -p "Hit Enter to $1 ..."
    fi
}

function install
{
    cmd=$1
    shift
    for pkg in "$@"; do
        exec="$cmd $pkg"
        #taskStatus "INSTALL" "Execute: $exec"
        if ${exec}; then
            echo "Installed $pkg"
        else
            echo "Failed to execute: $exec"
            if [[ ! -z "${CI}" ]]; then
                exit 1
            fi
        fi
    done
}

function brew_install_or_upgrade
{
    if brew ls --versions "$1" >/dev/null; then
        if (brew outdated | grep "$1" >/dev/null); then
            echo "Upgrading already installed package $1 ..."
            brew upgrade "$1"
        else
            echo "Latest $1 is already installed"
        fi
    else
        brew install "$1"
    fi
}

if [[ -z "${CI}" ]]; then
    sudo -v # Ask for the administrator password upfront
    # Keep-alive: update existing `sudo` time stamp until script has finished
    while true; do
                 sudo -n true
                               sleep 60
                                         kill -0 "$$" || exit
    done                                                            2>/dev/null &
fi

if test ! "$(command -v brew)"; then
    taskStatus "INSTALL" "Install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    if [[ -z "${CI}" ]]; then
        taskStatus "INSTALL" "Update Homebrew"
        brew update
        brew upgrade
        brew doctor
    fi
fi
export HOMEBREW_NO_AUTO_UPDATE=1

taskName "Install important software ..."
brew tap homebrew/cask-versions
install 'brew cask install' "${important_casks[@]}"

taskStatus "INSTALL" "Install packages"
install 'brew_install_or_upgrade' "${brews[@]}"
brew link --overwrite ruby

taskStatus "INSTALL" "Install JDK=${JDK_VERSION}"
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
jabba install ${JDK_VERSION}
jabba alias default ${JDK_VERSION}
java -version

taskStatus "INSTALL" "Set git defaults"
for config in "${git_configs[@]}"; do
    git config --global ${config}
done

if [[ -z "${CI}" ]]; then
    gpg --keyserver hkp://pgp.mit.edu --recv ${gpg_key}
    taskStatus "INSTALL" "Export key to Github"
    ssh-keygen -t rsa -b 4096 -C ${git_email}
    pbcopy <~/.ssh/id_rsa.pub
    open https://github.com/settings/ssh/new
fi

taskStatus "INSTALL" "Upgrade bash"
brew install bash bash-completion2 fzf
sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"
sudo chsh -s "$(brew --prefix)"/bin/bash
# Install https://github.com/twolfson/sexy-bash-prompt
touch ~/.bash_profile # see https://github.com/twolfson/sexy-bash-prompt/issues/51
(cd /tmp && git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt && cd sexy-bash-prompt && make install) && source ~/.bashrc
hstr --show-configuration >>~/.bashrc

echo "
alias del='mv -t ~/.Trash/'
alias ls='exa -l'
alias cat=bat
" >>~/.bash_profile

taskStatus "INSTALL" "Setting up xonsh"
sudo bash -c "which xonsh >> /private/etc/shells"
sudo chsh -s $(which xonsh)
echo "source-bash --overwrite-aliases ~/.bash_profile" >>~/.xonshrc

taskStatus "INSTALL" "Install software"
install 'brew cask install' "${casks[@]}"

taskStatus "INSTALL" "Install secondary packages"
install 'pip3 install --upgrade' "${pips[@]}"
install 'gem install' "${gems[@]}"
install 'npm install --global' "${npms[@]}"
install 'code --install-extension' "${vscode[@]}"
#brew tap caskroom/fonts
#install 'brew cask install' "${fonts[@]}"

taskStatus "INSTALL" "Update packages"
pip3 install --upgrade pip setuptools wheel
if [[ -z "${CI}" ]]; then
    m update install all
fi

if [[ -z "${CI}" ]]; then
    taskStatus "INSTALL" "Install software from App Store"
    mas list
fi

taskStatus "INSTALL" "Cleanup"
brew cleanup

echo "Done!"
