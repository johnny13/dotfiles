JDK_VERSION="amazon-corretto@1.8.222-10.1"

declare -a fonts=(
    font-fira-code
    font-source-code-pro
)

git_email='derek@huement.com'
declare -a git_configs=(
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

declare -a pips=(
    pip
    glances
    ohmu
    pythonpy
)

declare -a gems=(
    bundler
)

# ------------------------------------------------------------------------------
rulemsg "Additional Dev Items"
# ------------------------------------------------------------------------------

PMSG "INFO" "Install JDK=${JDK_VERSION}"
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
jabba install ${JDK_VERSION}
jabba alias default ${JDK_VERSION}
java -version

##
## TODO FIX CASKROOM FONTS!
# PMSG "INFO" "Fonts Installer"
# brew tap caskroom/fonts
# install 'brew cask install' "${fonts[@]}"

PMSG "INFO" "Set git defaults"
for config in "${git_configs[@]}"; do
    git config --global ${config}
done

PMSG "INFO" "BASH Additionals"
brew install bash bash-completion@2 fzf wget
brew install --appdir="~/Applications" xquartz --cask

PMSG "INFO" "Install Python packages"
brew install python
brew install python3
install 'pip3 install --upgrade' "${pips[@]}"
pip3 install --upgrade pip setuptools wheel

##
## TODO FIX RUBY INSTALL. NEEDS ROOT!
# PMSG "INFO" "Install Ruby + Gems packages"
# brew install ruby-build
# brew install rbenv
# LINE='eval "$(rbenv init -)"'
# grep -q "$LINE" ~/.extra || echo "$LINE" >>~/.extra
# install 'gem install' "${gems[@]}"

PMSG "INFO" "Android Setup"
#brew cask install --appdir="~/Applications" java
#brew cask install --appdir="~/Applications" intellij-idea-ce
brew install --appdir="~/Applications" android-studio --cask
brew install android-sdk

PMSG "INFO" "QuickLook Plugins"
brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzip qlimagesize webpquicklook suspicious-package quicklookase qlvideo --cask

PMSG "INFO" "Install font tools."
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

PMSG "INFO" "Install some CTF tools; see https://github.com/ctfs/write-ups."
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
#brew install homebrew/x11/xpdf
brew install xz

PMSG "INFO" "Install other useful binaries."
brew install ack
brew install dark-mode
#brew install exiv2
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
brew install hub
brew install imagemagick
brew install lua
brew install lynx
brew install micro
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rhino
brew install speedtest_cli
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install zopfli
brew install pkg-config libffi
brew install pandoc
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Remove outdated versions from the cellar.
brew cleanup

echo ""

ruleln "-" 60

echo ""
echo ""

finishEcho "MacOS Section Complete"

echo ""
