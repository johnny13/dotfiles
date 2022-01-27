##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
taskName "Dotfiles"
taskStatus "SETUP" "CLONING DOTFILES REPO"
mkdir -p "${rcDir}"
git clone "https://github.com/johnny13/dotfiles"

echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
source  ~/.bashrc

lineBreak

##
## RUST SETUP
##

taskName "Rust"
taskStatus "INSTALL" "RUST + CARGO CRATES"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

cargo install eureka
cargo install exa
cargo install pastel
lineBreak

finishEcho "BOX SETUP"
