#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    apt-fast install --no-install-recommends -y python-dbus
    sudo pip install ntfy
}

main() {
    if ! _is_service_exist ntfy; then
        install
    fi
}

main
