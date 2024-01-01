#!/bin/bash

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
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y

sudo apt-get autoremove -y

sudo apt-get install -y git \
    bison \
    flex \
    curl \
    wget \
    tcpdump \
    debconf-utils \
    python \
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
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install wireshark
echo -e "\n\n#####################################"
echo -e "\n-Installing wireshark"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y wireshark

echo -e "\n\n#####################################"
echo -e "\n- Terminal config"
sudo ln -s /usr/bin/xfce4-terminal /usr/bin/gnome-terminal

# Create virtual environments
echo -e "\n\n#####################################"
echo -e "\n-Creating virtual environments"
python3 -m venv "$VENV_PATH"/rose-venv
python3 -m venv "$VENV_PATH"/mininet-venv
python3 -m venv "$VENV_PATH"/controller-venv
python3 -m venv "$VENV_PATH"/node-mgr-venv
python3 -m venv "$VENV_PATH"/srv6-apps-venv

# Install wheel package
echo -e "\n\n#####################################"
echo -e "\n-Installing wheel"
# activate scripts are generated a run-time, therefore it is not possible
# to validate them with shellcheck. We need to disable the check SC1090
# in order to avoid annoying warnings "Can't follow non-constant source"
#
# shellcheck source=/dev/null
source "$VENV_PATH"/rose-venv/bin/activate
pip install wheel
deactivate
# shellcheck source=/dev/null
source "$VENV_PATH"/mininet-venv/bin/activate
pip install wheel
deactivate
# shellcheck source=/dev/null
source "$VENV_PATH"/controller-venv/bin/activate
pip install wheel
deactivate
# shellcheck source=/dev/null
source "$VENV_PATH"/node-mgr-venv/bin/activate
pip install wheel
deactivate
# shellcheck source=/dev/null
source "$VENV_PATH"/srv6-apps-venv/bin/activate
pip install wheel
deactivate

#cd $WORKSPACE_DIR
cd "$HOME_DIR" || {
    echo "Failure"
    exit 1
}

# Install FRR
echo -e "\n\n#####################################"
echo -e "\n-Installing FRR"

# Install from source
wget https://github.com/FRRouting/frr/archive/frr-7.3.1.zip
unzip frr-7.3.1.zip
cd frr-frr-7.3.1 || {
    echo "Failure"
    exit 1
}
sudo apt-get install -y dh-autoreconf
./bootstrap.sh

sudo groupadd -r -g 92 frr
sudo groupadd -r -g 85 frrvty
sudo adduser --system --ingroup frr --home /var/run/frr/ \
    --gecos "FRR suite" --shell /sbin/nologin frr
sudo usermod -a -G frrvty frr

sudo apt-get install -y \
    git autoconf automake libtool make libreadline-dev texinfo \
    pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
    libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
    install-info build-essential libsystemd-dev libsnmp-dev perl libcap-dev libyang-dev

ls -la

./configure \
    --prefix=/usr \
    --includedir=/usr/include \
    --enable-exampledir=/usr/share/doc/frr/examples \
    --bindir=/usr/bin \
    --sbindir=/usr/lib/frr \
    --libdir=/usr/lib/frr \
    --libexecdir=/usr/lib/frr \
    --localstatedir=/var/run/frr \
    --sysconfdir=/etc/frr \
    --with-moduledir=/usr/lib/frr/modules \
    --with-libyang-pluginsdir=/usr/lib/frr/libyang_plugins \
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

cd .. || {
    echo "Failure"
    exit 1
}
rm frr-7.3.1.zip

cd "$WORKSPACE_DIR" || {
    echo "Failure"
    exit 1
}

# during the build phase, the rose-vm repo is cloned with
# the explicit clone command
# then all the other repos are cloned using the script
# update_all_body.sh clone_repos
# which has been just cloned

# Clone rose vm repo
echo -e "\n\n#####################################"
echo -e "\n-Clone rose-vm repo"
git clone https://github.com/netgroup/rose-vm.git
cd rose-vm || {
    echo "Failure"
    exit 1
}
git pull

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

echo -e "\n\n#####################################"
echo -e "\n-setup_controller"
"$ROSE_VM_SCRIPTS/setup_controller.sh"
echo -e "\n\n#####################################"
echo -e "\n-setup_node_mgr"
"$ROSE_VM_SCRIPTS/setup_node_mgr.sh"
echo -e "\n\n#####################################"
echo -e "\n-setup_srv6_tutorial"
"$ROSE_VM_SCRIPTS/setup_srv6_tutorial.sh"
#echo -e "\n\n#####################################"
#echo -e "\n-build_deploy_docker_stack"
#"$ROSE_VM_SCRIPTS/build_deploy_docker_stack.sh"

# End of setup
echo -e "\n\n#####################################"
echo -e "\n-End of setup"
