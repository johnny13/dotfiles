
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor

brew install make git wget openssl openssh

xcode-select --install

curl https://getmic.ro | bash

#echo "options vfio-pci ids=8086:9d2f,10de:0fb9 disable_vga=1" > /etc/modprobe.d/vfio.conf
