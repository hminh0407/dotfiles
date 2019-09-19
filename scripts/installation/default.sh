#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

install () {
    /bin/bash -c "$(curl -sL https://git.io/vokNn)"

    # install essential apt packages
    apt-fast install --no-install-recommends -y \
        snapd curl exuberant-ctags rename ncdu wget xclip undistract-me

    # create a folder to contain user specific cli execution files
    mkdir -p "${HOME}"/cli
}

main () {
    if ! isServiceExist apt-fast; then
        install
    fi
}

main
