#!/bin/bash

sudo su rose

HOME_DIR="$HOME"
WORKSPACE_DIR="$HOME_DIR/workspace"
MININET_DIR="$HOME_DIR/mininet"
ROSE_SYS_DIR="$HOME_DIR/.rose"

export TERM=linux

# Update apt
sudo apt-get update

sudo apt autoremove -y

sudo apt-get install -y git-core

git config --global user.email "rose_project@rose_project.org"
git config --global user.name "The ROSE project"

# Install bison
echo -e "\n\n#####################################"
echo -e "\n-Installing bison"
sudo apt-get install -y bison

# Install flex
echo -e "\n\n#####################################"
echo -e "\n-Installing flex"
sudo apt-get install -y flex

# Install sudo
echo -e "\n\n#####################################"
echo -e "\n-Installing sudo"
sudo apt-get install -y sudo

# Install sublime evaluation version
echo -e "\n\n#####################################"
echo -e "\n-Installing sublime evaluation version"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text

# Install tcpdump
echo -e "\n\n#####################################"
echo -e "\n-Installing tcpdump"
sudo apt-get install -y tcpdump

# Install debconf-utils
echo -e "\n\n#####################################"
echo -e "\n-Installing debconf-utils"
sudo apt-get install -y debconf-utils

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install wireshark
echo -e "\n\n#####################################"
echo -e "\n-Installing wireshark"
DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y wireshark
DEBIAN_FRONTEND=

mkdir -p $WORKSPACE_DIR
mkdir -p $ROSE_SYS_DIR

cd $WORKSPACE_DIR

# Clone rose vm repo
echo -e "\n\n#####################################"
echo -e "\n-Clone rose-vm repo"
git clone https://github.com/netgroup/rose-vm.git
cd rose-vm

# Clone all other repos
echo -e "\n\n#####################################"
echo -e "\n-Clone all other repos"
chmod +x "$WORKSPACE_DIR/rose-vm/scripts/update_all.sh"
chmod +x "$WORKSPACE_DIR/rose-vm/scripts/update_all_body.sh"
"$WORKSPACE_DIR/rose-vm/scripts/update_all_body.sh" clone_repos

# Initial setup of ROSE desktop environment
echo -e "\n\n#####################################"
echo -e "\n-Initial setup of ROSE desktop environment"
chmod +x "$ROSE_SYS_DIR/rose-vm-build/initial-setup/initial-desktop-setup.sh"
"$ROSE_SYS_DIR/rose-vm-build/initial-setup/initial-desktop-setup.sh"





