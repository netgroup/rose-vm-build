#!/bin/bash

sudo bash << EOF
#disable auto upgrades
sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/20auto-upgrades

# User rose needs to sudo without password
echo "rose        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rose
chmod 0440 /etc/sudoers.d/rose

chmod +x /tmp/execute-xubuntu-vagrant-vbox-from-box.sh
EOF

sudo -i -u rose bash /tmp/execute-xubuntu-vagrant-vbox-from-box.sh

