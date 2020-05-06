#!/bin/bash

sudo bash << EOF
# User rose needs to sudo without password
echo "rose        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rose
chmod 0440 /etc/sudoers.d/rose
EOF

sudo -i -u rose bash ./execute-xubuntu-vagrant-vbox-from-box.sh

