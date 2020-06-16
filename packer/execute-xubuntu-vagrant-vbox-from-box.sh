#!/bin/bash

ROSE_USER="rose"

HOME_DIR="$HOME"
WORKSPACE_DIR="$HOME_DIR/workspace"
ROSE_VM_SCRIPTS="$WORKSPACE_DIR/rose-vm/scripts"
MININET_DIR="$HOME_DIR/mininet"
ROSE_SYS_DIR="$HOME_DIR/.rose"
ROSE_SYS_INITIAL_SETUP="$ROSE_SYS_DIR/rose-vm-build/initial-setup"
VENV_PATH="$HOME/.envs"

# possible values for FRRVER: frr-6 frr-7 frr-stable
# frr-stable will be the latest official stable release
FRRVER="frr-stable"

# NB: FRR is not yet released for "focal" release
#RELEASE=$(lsb_release -s -c)
RELEASE="bionic"

export TERM="linux"

echo "HOME=$HOME"
echo "HOME_DIR=$HOME_DIR"
echo "WORKSPACE_DIR=$WORKSPACE_DIR"

cd $HOME_DIR

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$ROSE_SYS_DIR"

# Update apt
sudo apt update

sudo apt autoremove -y

sudo apt install -y git-core

git config --global user.email "rose_project@rose_project.org"
git config --global user.name "The ROSE project"

# Install bison
echo -e "\n\n#####################################"
echo -e "\n-Installing bison"
sudo apt install -y bison

# Install flex
echo -e "\n\n#####################################"
echo -e "\n-Installing flex"
sudo apt install -y flex

# Install sudo
echo -e "\n\n#####################################"
echo -e "\n-Installing sudo"
sudo apt install -y sudo

# Install curl
echo -e "\n\n#####################################"
echo -e "\n-Installing curl"
sudo apt install -y curl

# Install wget
echo -e "\n\n#####################################"
echo -e "\n-Installing wget"
sudo apt install -y wget


# Install Chrome
echo -e "\n\n#####################################"
echo -e "\n-Installing Chrome"

sudo apt install -y gdebi-core
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb


# Install sublime evaluation version
echo -e "\n\n#####################################"
echo -e "\n-Installing sublime evaluation version"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text

# Install tcpdump
echo -e "\n\n#####################################"
echo -e "\n-Installing tcpdump"
sudo apt install -y tcpdump

# Install debconf-utils
echo -e "\n\n#####################################"
echo -e "\n-Installing debconf-utils"
sudo apt install -y debconf-utils

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install wireshark
echo -e "\n\n#####################################"
echo -e "\n-Installing wireshark"
DEBIAN_FRONTEND=noninteractive
sudo apt install -y wireshark
DEBIAN_FRONTEND=

# Install docker
echo -e "\n\n#####################################"
echo -e "\n-Installing docker"
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$ROSE_USER"

# Install python2
echo -e "\n\n#####################################"
echo -e "\n-Installing python2"
sudo apt install -y python

# Install python3
echo -e "\n\n#####################################"
echo -e "\n-Installing python3"
sudo apt install -y python3

# Install python3-venv
echo -e "\n\n#####################################"
echo -e "\n-Installing python3-venv"
sudo apt-get install -y python3-venv

# Install python3-pip
echo -e "\n\n#####################################"
echo -e "\n-Installing python3-pip"
sudo apt-get install python3-pip

# Install Mininet
echo -e "\n\n#####################################"
echo -e "\n-Installing Mininet"
sudo apt install -y mininet
sudo ln -s /usr/bin/xfce4-terminal /usr/bin/gnome-terminal


# Install vim
echo -e "\n\n#####################################"
echo -e "\n-Installing vim"
sudo apt install -y vim

# Create virtual environments
echo -e "\n\n#####################################"
echo -e "\n-Creating virtual environments"
python3 -m venv $VENV_PATH/rose-venv
python3 -m venv $VENV_PATH/mininet-venv
python3 -m venv $VENV_PATH/controller-venv
python3 -m venv $VENV_PATH/node-mgr-venv

#cd $WORKSPACE_DIR
cd $HOME_DIR

# Install FRR
echo -e "\n\n#####################################"
echo -e "\n-Installing FRR"

# # Install from package
# # add GPG key
# wget https://deb.frrouting.org/frr/keys.asc 
# sudo apt-key add keys.asc
# rm keys.asc
# echo deb https://deb.frrouting.org/frr $RELEASE $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list
# # update and install FRR
# sudo apt update && sudo apt -y install frr frr-pythontools

# Install from source
wget https://github.com/FRRouting/frr/archive/frr-7.3.1.zip
unzip frr-7.3.1.zip
cd frr-frr-7.3.1
sudo apt install -y dh-autoreconf
./bootstrap.sh

sudo groupadd -r -g 92 frr
sudo groupadd -r -g 85 frrvty
sudo adduser --system --ingroup frr --home /var/run/frr/ \
   --gecos "FRR suite" --shell /sbin/nologin frr
sudo usermod -a -G frrvty frr

sudo apt install -y \
git autoconf automake libtool make libreadline-dev texinfo \
pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
install-info build-essential libsystemd-dev libsnmp-dev perl libcap-dev

sudo apt install -y libyang-dev

./configure \
    --prefix=/usr \
    --includedir=\${prefix}/include \
    --enable-exampledir=\${prefix}/share/doc/frr/examples \
    --bindir=\${prefix}/bin \
    --sbindir=\${prefix}/lib/frr \
    --libdir=\${prefix}/lib/frr \
    --libexecdir=\${prefix}/lib/frr \
    --localstatedir=/var/run/frr \
    --sysconfdir=/etc/frr \
    --with-moduledir=\${prefix}/lib/frr/modules \
    --with-libyang-pluginsdir=\${prefix}/lib/frr/libyang_plugins \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-snmp=agentx \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --with-pkg-git-version \
    --disable-ripd \
    --disable-ripngd \
    --disable-ospfd \
    --disable-ospf6d \
    --disable-bgpd \
    --disable-ldpd \
    --disable-nhrpd \
    --disable-eigrpd \
    --disable-babeld \
    --disable-watchfrr \
    --disable-pimd \
    --disable-vrrpd \
    --disable-pbrd \
    --disable-bgp-announce \
    --disable-bgp-vnc \
    --disable-bgp-bmp \
    --disable-ospfapi \
    --disable-ospfclient \
    --disable-fabricd \
    --disable-irdp \
    --enable-shell-access \
    --with-pkg-extra-version=-FRR_Rose
make
sudo make install

cd ..
rm frr-7.3.1.zip




cd $WORKSPACE_DIR

# during the build phase, the rose-vm repo is cloned with
# the explicit clone command
# then all the other repos are cloned using the script
# update_all_body.sh clone_repos
# which has been just cloned

# Clone rose vm repo
echo -e "\n\n#####################################"
echo -e "\n-Clone rose-vm repo"
git clone https://github.com/netgroup/rose-vm.git
cd rose-vm

# Clone all other repos
echo -e "\n\n#####################################"
echo -e "\n-Clone all other repos"


find "$ROSE_VM_SCRIPTS" -type f -exec chmod +x {} \;
"$ROSE_VM_SCRIPTS/update_all_body.sh" clone_repos


# Initial setup of ROSE desktop environment
echo -e "\n\n#####################################"
echo -e "\n-Initial setup of ROSE desktop environment"
find "$ROSE_SYS_INITIAL_SETUP" -type f -name "*.sh" -exec chmod +x {} \;
"$ROSE_SYS_INITIAL_SETUP/initial-desktop-setup.sh"

# End of setup
echo -e "\n\n#####################################"
echo -e "\n-End of setup"

