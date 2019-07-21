#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
}

main () {
    if !isServiceExist calibre; then
        install
    fi
}

main
