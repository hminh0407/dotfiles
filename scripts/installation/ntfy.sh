#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

install () {
    apt-fast install --no-install-recommends -y python-dbus
    sudo pip install ntfy
}

main() {
    if ! isServiceExist ntfy; then
        install
    fi
}

main
