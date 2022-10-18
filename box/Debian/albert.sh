#/usr/bin/env bash

echo "Albert Install Script"

echo ""
echo "Repo Setup"
echo ""

curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
sudo wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_20.04/Release.key -O "/etc/apt/trusted.gpg.d/home:manuelschneid3r.asc"

echo ""
echo "Updating!"
echo ""

sudo apt update -y

echo ""
echo "Installing!"
echo ""

sudo apt install -y albert

echo ""
echo "Finished!"
echo ""
