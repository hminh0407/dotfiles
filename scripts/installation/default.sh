#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install() {
    /bin/bash -c "$(curl -sL https://git.io/vokNn)"

    # install essential apt packages
    apt-fast install --no-install-recommends -y \
        snapd curl exuberant-ctags rename ncdu wget xclip powerline fonts-powerline

    # create a folder to contain user specific cli execution files
    mkdir -p "${HOME}"/bin

    # install essential pip tool
    sudo pip install csvkit
}

main() {
    if ! _is_service_exist apt-fast; then
        install
    fi
}

main
