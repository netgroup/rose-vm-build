#!/bin/bash

ROSE_USER="rose"

# Install docker
echo -e "\n\n#####################################"
echo -e "\n-Installing docker"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$ROSE_USER"



