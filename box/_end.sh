##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
taskName "Dotfiles"
taskStatus "SETUP" "CLONING DOTFILES REPO"
#mkdir -p "${rcDir}"
if [ -d "${rcDir}" ]; then
    rm -r $rcDir
fi

git clone "https://github.com/johnny13/dotfiles" $rcDir

#echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
#source  ~/.bashrc

lineBreak

##
## RUST SETUP
##

taskName "Rust"
taskStatus "INSTALL" "RUST + CARGO CRATES"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

rustup component add clippy

cargo install eureka
cargo install exa
cargo install pastel
lineBreak

finishEcho "BOX SETUP"
