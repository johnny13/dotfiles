##
## DOTFILES SETUP
##

rcDir="${HOME}/.dotfiles"
rulemsg "RC Dotfiles"
PMSG "INFO" "CLONING DOTFILES REPO"
#mkdir -p "${rcDir}"
if [ -d "${rcDir}" ]; then
    rm -r $rcDir
fi

git clone "https://github.com/johnny13/dotfiles" $rcDir

#echo  'export PATH="${HOME}/.local/bin:$PATH"' >>~/.bashrc
#source  ~/.bashrc

ruleln "-" 60

##
## RUST SETUP
##

rulemsg "Rust Setup"
PMSG "INFO" "RUST + CARGO CRATES"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

rustup component add clippy

cargo install eureka
cargo install exa
cargo install pastel

ruleln "-" 60

finishEcho "BOX SETUP"
