#!/bin/bash

# User rose needs to sudo without password
sudo echo "rose        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rose
sudo chmod 0440 /etc/sudoers.d/rose

sudo chmod +x /tmp/execute-xubuntu-vagrant-vbox-from-box.sh
sudo -i -u rose bash /tmp/execute-xubuntu-vagrant-vbox-from-box.sh

