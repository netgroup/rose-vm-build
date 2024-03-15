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
