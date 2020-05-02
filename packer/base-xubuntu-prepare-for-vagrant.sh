#!/bin/bash
#run this script as root

# Vagrant specific
date > /etc/vagrant_box_build_time

# Add vagrant user /usr/sbin/groupadd vagrant (-G wheel is useful for centOS)
/usr/sbin/useradd vagrant -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

#add rose user to sudoers
#echo "rose       ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rose
#chmod 0440 /etc/sudoers.d/rose

#add rose user to sudoers
echo "user       ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/user
chmod 0440 /etc/sudoers.d/user


# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd