#!/bin/bash
# Initial desktop setup

sudo -i -u rose bash << EOF

HOME_DIR=$HOME
WORKSPACE_DIR="$HOME_DIR/workspace"
MININET_DIR="$HOME_DIR/mininet"
ROSE_SYS_DIR="$HOME_DIR/.rose"

echo $HOME_DIR
echo $HOME_DIR

ROSE_VM_DESKTOP_FILE_NAME="ROSE-v2.0"

cd $ROSE_SYS_DIR/rose-vm-build/initial-setup/

cp Desktop/exo-terminal-emulator.desktop "$HOME_DIR/Desktop"
chmod 755 "$HOME_DIR/Desktop/exo-terminal-emulator.desktop"

sudo cp icons-images/xubuntu-focal-rose.png /usr/share/xfce4/backdrops/

cp xfce4-desktop.xml "$HOME_DIR/.config/xfce4/xfconf/xfce-perchannel-xml/"

cp Desktop/update.desktop "$HOME_DIR/Desktop"
chmod +x "$HOME_DIR/Desktop/update.desktop"

cp Desktop/check-status.desktop "$HOME_DIR/Desktop"
chmod +x "$HOME_DIR/Desktop/check-status.desktop"

cp Desktop/wireshark.desktop "$HOME_DIR/Desktop"
chmod +x "$HOME_DIR/Desktop/wireshark.desktop"

cd $HOME_DIR

ln -s "$WORKSPACE_DIR/rose-vm/vm-docs/ROSE-VM-README.txt" "$HOME_DIR/Desktop/README.txt"
cp "$WORKSPACE_DIR/rose-vm/vm-docs/$ROSE_VM_DESKTOP_FILE_NAME" $HOME_DIR/Desktop/

# TODO : go icon
#cp $WORKSPACE_DIR/Mantoo-scripts-and-readme/VM-Desktop/go-v2.desktop $HOME_DIR/Desktop/

# TODO (?) : stop icon
#cp $WORKSPACE_DIR/Mantoo-scripts-and-readme/VM-Desktop/stop-v2.desktop $HOME_DIR/Desktop/

EOF