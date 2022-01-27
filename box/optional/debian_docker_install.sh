#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo ""
echo ""
echo "    █████████            █████       ██████████                     █████                          "                
echo "   ███░░░░░███          ░░███       ░░███░░░░███                   ░░███                           "
echo "  ███     ░░░   ██████  ███████      ░███   ░░███  ██████   ██████  ░███ █████  ██████  ████████   "
echo " ░███          ███░░███░░░███░       ░███    ░███ ███░░███ ███░░███ ░███░░███  ███░░███░░███░░███  "
echo " ░███    █████░███████   ░███        ░███    ░███░███ ░███░███ ░░░  ░██████░  ░███████  ░███ ░░░   "
echo " ░░███  ░░███ ░███░░░    ░███ ███    ░███    ███ ░███ ░███░███  ███ ░███░░███ ░███░░░   ░███       "
echo "  ░░█████████ ░░██████   ░░█████     ██████████  ░░██████ ░░██████  ████ █████░░██████  █████      "
echo "   ░░░░░░░░░   ░░░░░░     ░░░░░     ░░░░░░░░░░    ░░░░░░   ░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░       "
echo ""
echo " ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  "
echo ""

echo ""
echo "Clearing out any old junk shit"
echo ""
sudo apt-get remove docker docker-engine docker.io containerd runc

echo ""
echo "Starting Install..."
echo ""
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo ""
echo "Secure Repo Add..."
echo ""
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
echo ""
echo "Updating & Finally installing..."
echo ""
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo ""
echo "Running Test..."
echo ""
sudo docker run hello-world


echo ""
echo ""
echo "Finished!"
echo ""
