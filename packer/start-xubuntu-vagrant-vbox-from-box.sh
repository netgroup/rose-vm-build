#!/bin/bash

VBOX_GA_VER = "6.1.6"

sudo apt-get update
sudo apt-get install -y linux-headers-$(uname -r) build-essential dkms

wget "http://download.virtualbox.org/virtualbox/$VBOX_GA_VER/VBoxGuestAdditions_$VBOX_GA_VER.iso"
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro "VBoxGuestAdditions_$VBOX_GA_VER.iso" /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm "VBoxGuestAdditions_$VBOX_GA_VER.iso"
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions


