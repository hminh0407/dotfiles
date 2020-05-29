#!/usr/bin/env bash

_installAptFast() {
    echo "... Installing apt-fast ..."
    sudo add-apt-repository -y ppa:apt-fast/stable
    sudo apt-get update -y \
        && sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y apt-fast
}

_installEssentials() {
    echo "... Installing Essential Packages ..."
    sudo apt-fast install --no-install-recommends -y \
        python3 python3-pip \
        g++ build-essential \
        gawk xclip wget curl exuberant-ctags ripgrep jq net-tools
}

_grantPermissions() {
    # make all sh file executable
    find . -type f -iname "*.sh" -exec chmod +x {} \;
}

_setupGlobal() {
    echo "... Setting up global config ..."

    mkdir -p $DOTFILES_BIN_DIR
    mkdir -p $DOTFILES_TMP_DIR

    # make python3 the default python. NOTE: only do this on ubuntu > 20.04
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
    sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
}

_installTerminalBundle() {
    echo "... Installing Terminal Bundle ..."
    ./install-profiles.sh terminal
}

_cleanup() {
    echo "... Cleaning up ..."
    sudo apt-get autoremove
}

install() {
    _installAptFast
    _installEssentials
    _grantPermissions
    _setupGlobal
    _installTerminalBundle
    _cleanup
}

install
