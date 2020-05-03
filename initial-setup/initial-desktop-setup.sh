#!/bin/bash
# Initial desktop setup

HOME_DIR=$HOME
WORKSPACE_DIR="$HOME_DIR/workspace"
MININET_DIR="$HOME_DIR/mininet"
ROSE_SYS_DIR="$HOME_DIR/.rose"

cd $ROSE_SYS_DIR/rose-vm-build/initial-setup/

cp Desktop/exo-terminal-emulator.desktop "$HOME_DIR/Desktop"
chmod 755 "$HOME_DIR/Desktop/exo-terminal-emulator.desktop"

sudo cp icons-images/xubuntu-focal-rose.png /usr/share/xfce4/backdrops/

cp xfce4-desktop.xml "$HOME_DIR/.config/xfce4/xfconf/xfce-perchannel-xml/"

