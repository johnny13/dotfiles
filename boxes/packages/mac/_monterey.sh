echo ""
echo ""
echo "      ${BCYN}========================${NC}"
echo "         ${BPUR}Research Chemicals"
echo "      ${BGRN}Laboratory Synchronizing"
echo "      ${BCYN}========================${NC}"
echo ""
echo ""

declare -a app_name=(
    "authy"
    "lastpass"
    "aerial"
    "barrier"
    "brave-browser"
    "cakebrew"
    "diffmerge"
    "discord"
    "docker"
    "figma"
    "firefox"
    "github"
    "google-chrome"
    "google-drive"
    "hyper"
    "insomnia"
    "iterm2"
    "launchcontrol"
    "rectangle"
    "sidekick"
    "slack"
    "sourcetree"
    "spotify"
    "stats"
    "transmission"
    "typora"
    "visual-studio-code"
    "warp"
    "zoom"
)

declare -a app_desc=(
    "Authy Desktop"
    "LastPass"
    "Aerial Screensaver"
    "Barrier"
    "Brave Browser"
    "Cakebrew"
    "DiffMerge"
    "Discord"
    "Docker"
    "Figma"
    "Mozilla Firefox"
    "GitHub Desktop"
    "Google Chrome"
    "Google Drive"
    "Hyper"
    "Insomnia"
    "iTerm"
    "LaunchControl"
    "Rectangle"
    "Sidekick"
    "Slack"
    "Sourcetree"
    "Spotify"
    "Stats"
    "Transmission"
    "Typora"
    "Visual Studio Code"
    "Warp"
    "Zoom.us"
)



# ------------------------------------------------------------------------------
rulemsg "MacOS default items + settings configuration"
# ------------------------------------------------------------------------------

get_consent "Create Dock spacers"
if has_consent; then
    PMSG "INFO" "Creating Dock spacers"
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    killall Dock
fi

get_consent "Autohide Dock"
if has_consent; then
    PMSG "INFO" "Autohiding Dock"
    defaults write com.apple.dock autohide -boolean true
    killall Dock
fi

get_consent "Display hidden Finder files/folders"
if has_consent; then
    PMSG "INFO" "Displaying hidden Finder files/folders"
    defaults write com.apple.finder AppleShowAllFiles -boolean true
    killall Finder
fi

if ! has_path "Developer"; then
    get_consent "Create ~/Developer folder"
    if has_consent; then
        PMSG "INFO" "Creating ~/Developer folder"
        mkdir -p ~/Developer
        test_path "Developer"
    fi
fi

if ! has_command "brew"; then
    PMSG "INFO" "Installing brew (Homebrew)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if has_arm; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew doctor
    brew tap homebrew/cask-fonts
    test_command "brew"
    export HOMEBREW_NO_AUTO_UPDATE=1
    PMSG "GOOD" "Homebrew Installed and Ready To Go!"
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Defaults Completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Tools setup + configurations"
# ------------------------------------------------------------------------------

if has_command "brew"; then
    if ! has_command "watchman"; then
        PMSG "INFO" "Installing watchman"
        brew install watchman
        test_command "watchman"
    fi
fi

if has_command "brew"; then
    if ! has_command "trash"; then
        PMSG "INFO" "Installing trash"
        brew install trash
        test_command "trash"
    fi
fi

if has_command "brew"; then
    if ! has_command "git"; then
        PMSG "INFO" "Installing git"
        brew install git
        test_command "git"
    fi
fi

if has_command "brew"; then
    if ! has_command "git-flow"; then
        PMSG "INFO" "Installing git-flow"
        brew install git-flow
        test_command "git-flow"
    fi
fi

if has_command "brew"; then
    if ! has_command "bash"; then
        PMSG "INFO" "Installing bash"
        brew install bash
        test_command "bash"
    fi
fi

if has_command "brew"; then
    if ! has_command "zsh"; then
        PMSG "INFO" "Installing zsh"
        brew install zsh
        test_command "zsh"
    fi
fi

if has_command "zsh"; then
    if ! has_path ".oh-my-zsh"; then
        PMSG "INFO" "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        test_path ".oh-my-zsh"
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "powerlevel10k"; then
        PMSG "INFO" "Installing powerlevel10k"
        brew install romkatv/powerlevel10k/powerlevel10k
        echo '# Theme configuration: PowerLevel10K' >>~/.zshrc
        echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
        echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' >>~/.zshrc
        echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >>~/.zshrc
        echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>~/.zshrc
        test_brew "powerlevel10k"
        p10k configure
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "zsh-autosuggestions"; then
        PMSG "INFO" "Installing zsh-autosuggestions"
        brew install zsh-autosuggestions
        echo "# Fish shell-like fast/unobtrusive autosuggestions for Zsh." >>~/.zshrc
        echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
        test_brew "zsh-autosuggestions"
    fi
fi

if has_command "brew" && has_command "zsh"; then
    if ! has_brew "zsh-syntax-highlighting"; then
        PMSG "INFO" "Installing zsh-syntax-highlighting"
        brew install zsh-syntax-highlighting
        echo "# Fish shell-like syntax highlighting for Zsh." >>~/.zshrc
        echo "# Warning: Must be last sourced!" >>~/.zshrc
        echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
        test_brew "zsh-syntax-highlighting"
    fi
fi

if has_command "brew"; then
    if ! has_command "node"; then
        PMSG "INFO" "Installing node"
        brew install node
        test_command "node"
    fi
fi

if has_command "brew"; then
    if ! has_command "n"; then
        PMSG "INFO" "Installing n"
        brew install n
        test_command "n"
    fi
fi

if has_command "brew"; then
    if ! has_command "nvm"; then
        PMSG "INFO" "Installing nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        test_command "nvm"
    fi
fi

if has_command "brew"; then
    if ! has_command "yarn"; then
        PMSG "INFO" "Installing yarn"
        brew install yarn
        test_command "yarn"
    fi
fi

if has_command "brew"; then
    if ! has_command "pnpm"; then
        PMSG "INFO" "Installing pnpm"
        brew install pnpm
        test_command "pnpm"
    fi
fi

if has_command 'npm'; then
    PMSG "INFO" "Upgrading npm"
    npm install --location=global npm@latest
    test_command "npm"
fi

if has_command "npm"; then
    PMSG "INFO" "Installing/Upgrading serve"
    npm install --location=global serve@latest
    test_command "serve"
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Tools completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Installing Applications/Casks"
# ------------------------------------------------------------------------------

if has_command "brew"; then
    for i in "${!app_name[@]}"; do
        DESC=${app_desc[$i]}
        NAME=${app_name[$i]}
        test_app "$DESC"
        if ! has_app "$DESC"; then
            PMSG "INFO" "Installing $NAME"
            brew install --cask $NAME
            test_app "$DESC"
        fi
    done
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Applications/Casks Install Completed"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Running Optimizations"
# ------------------------------------------------------------------------------

get_consent "Re-sort Launchpad applications"
if has_consent; then
    PMSG "INFO" "Re-sorting Launchpad applications"
    defaults write com.apple.dock ResetLaunchPad -boolean true
    killall Dock
fi

if has_command "zsh"; then
    if has_path ".oh-my-zsh"; then
        PMSG "INFO" "Updating oh-my-zsh"
        $ZSH/tools/upgrade.sh
        test_path ".oh-my-zsh"
    fi
fi

if has_command "brew"; then
    get_consent "Optimize Homebrew"
    if has_consent; then
        PMSG "INFO" "Running brew update"
        brew update
        PMSG "INFO" "Running brew upgrade"
        brew upgrade
        PMSG "INFO" "Running brew doctor"
        brew doctor
        PMSG "INFO" "Running brew cleanup"
        brew cleanup
    fi
fi

# ------------------------------------------------------------------------------
PMSG "GOOD" "Optimizations complete"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
rulemsg "Creating Homebrew Summary"
# ------------------------------------------------------------------------------

PMSG "GOOD" "$(uname -p) Architecture"
if has_path "Developer"; then
    PMSG "GOOD" "~/Developer"
else
    PMSG "WARN" "~/Developer"
fi

test_command "xcode-select"
test_command "brew"
test_command "watchman"
test_command "trash"
test_command "git"
test_command "git-flow"
test_command "zsh"
test_path ".oh-my-zsh"
test_brew "powerlevel10k"
test_brew "zsh-autosuggestions"
test_brew "zsh-syntax-highlighting"
test_command "node"
test_command "n"
test_command "nvm"
test_command "yarn"
test_command "pnpm"
test_command "npm"
test_command "serve"

test_app "Brave Browser"
test_app "DiffMerge"
test_app "Discord"
test_app "Figma"
test_app "Google Chrome"
test_app "Insomnia"
test_app "iTerm"
test_app "Rectangle"
test_app "Slack"
test_app "Sourcetree"
test_app "Spotify"
test_app "Visual Studio Code"
test_app "Warp"
test_app "Zoom.us"

# ------------------------------------------------------------------------------
PMSG "GOOD" "Summary complete"
# ------------------------------------------------------------------------------

PMSG "INFO" "Cleaning Up Homebrew"
brew cleanup
