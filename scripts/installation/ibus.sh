#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    sudo add-apt-repository -y ppa:teni-ime/ibus-teni
    apt-fast install -y --no-install-recommends ibus ibus-teni

    # setup ibus input
    ibus restart
    # to setup vietnamese keyboard follow instruction on
    # https://github.com/teni-ime/ibus-teni/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%E1%BA%A5u-h%C3%ACnh#1-keyboard-input-method-system-ibus
    # https://github.com/teni-ime/ibus-teni/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%E1%BA%A5u-h%C3%ACnh#2-add-an-input-source-vietnameseteni
}

main () {
    if !isServiceExist ibus; then
        install
    fi
}

main
