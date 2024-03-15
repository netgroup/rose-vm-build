#!/bin/bash

# this script is used to build a generic development VM
# after the initial setup performed with packer/base-xubuntu-prepare-for-vagrant.sh
# the ROSE specific part is not included
# the Docker installation is not included


HOME_DIR="$HOME"
WORKSPACE_DIR="$HOME_DIR/workspace"
ROSE_VM_SCRIPTS="$WORKSPACE_DIR/rose-vm/scripts"

ROSE_SYS_DIR="$HOME_DIR/.rose"
ROSE_SYS_INITIAL_SETUP="$ROSE_SYS_DIR/rose-vm-build/initial-setup"
VENV_PATH="$HOME/.envs"

export TERM="linux"

echo "HOME=$HOME"
echo "HOME_DIR=$HOME_DIR"
echo "WORKSPACE_DIR=$WORKSPACE_DIR"

cd "$HOME_DIR" || {
    echo "Failure"
    exit 1
}

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$ROSE_SYS_DIR"

# Update apt
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y

sudo apt-get autoremove -y

sudo apt-get install -y git \
    bison \
    flex \
    curl \
    wget \
    tcpdump \
    debconf-utils \
    python2 \
    python3 \
    python3-venv \
    python3-pip \
    vim \
    mininet \
    gdebi-core

git config --global user.email "rose_project@rose_project.org"
git config --global user.name "The ROSE project"

# Install Chrome
echo -e "\n\n#####################################"
echo -e "\n-Installing Chrome"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install sublime evaluation version
echo -e "\n\n#####################################"
echo -e "\n-Installing sublime evaluation version"
#wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y sublime-text

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install wireshark
echo -e "\n\n#####################################"
echo -e "\n-Installing wireshark"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y wireshark

echo -e "\n\n#####################################"
echo -e "\n- Terminal config"
sudo ln -s /usr/bin/xfce4-terminal /usr/bin/gnome-terminal
