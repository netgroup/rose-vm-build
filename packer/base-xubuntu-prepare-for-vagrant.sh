#!/bin/bash
# run this script as root

#Virtualbox guest additions version
VBOX_GA_VER="6.1.6"


apt-get update
apt-get install -y openssh-server

# Vagrant specific
date > /etc/vagrant_box_build_time

# Add vagrant user with password vagrant
useradd -m -p $(openssl passwd -1 vagrant) -s /bin/bash -c vagrant vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to the ROSE project VM.' > /etc/motd

# this is for mininet
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

echo "root:root" | chpasswd

# In order to keep SSH speedy even when your machine or the Vagrant machine is not connected to the internet
sed -i 's/#UseDNS no/UseDNS no/' /etc/ssh/sshd_config

service ssh restart

apt-get install -y linux-headers-$(uname -r) gcc build-essential dkms

wget "http://download.virtualbox.org/virtualbox/$VBOX_GA_VER/VBoxGuestAdditions_$VBOX_GA_VER.iso"
mkdir /media/VBoxGuestAdditions
mount -o loop,ro "VBoxGuestAdditions_$VBOX_GA_VER.iso" /media/VBoxGuestAdditions
sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm "VBoxGuestAdditions_$VBOX_GA_VER.iso"
umount /media/VBoxGuestAdditions
rmdir /media/VBoxGuestAdditions

rm ini.sh

