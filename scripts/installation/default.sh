#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    sudo add-apt-repository -y ppa:apt-fast/stable
    sudo apt-get install -y --no-install-recommends apt-fast

    # install apt packages
    apt-fast install --no-install-recommends -y                                  \
        snapd gnome-tweak-tool gnome-shell-extensions network-manager-l2tp-gnome \
        curl exuberant-ctags silversearcher-ag rename ncdu wget xclip tig        \
        python-pip python-dev python-setuptools

    # create a folder to contain user specific cli execution files
    mkdir -p "${HOME}"/cli
}

main () {
    if ! isServiceExist apt-fast; then
        install
    fi
}

main
