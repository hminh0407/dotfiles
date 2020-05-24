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
        gawk xclip wget curl exuberant-ctags ripgrep jq
}

_grantPermissions() {
    # make all sh file executable
    find . -type f -iname "*.sh" -exec chmod +x {} \;
}

_setupGlobal() {
    echo "... Setting up global config ..."

    mkdir -p $DOTFILES_BIN_DIR
    mkdir -p $DOTFILES_TMP_DIR
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
