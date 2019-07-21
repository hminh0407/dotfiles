#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

declare BAT_VERSION="0.6.1"

install () {
    wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb \
        -O /tmp/bat_${BAT_VERSION}_amd64.deb
    sudo dpkg -i /tmp/bat_${BAT_VERSION}_amd64.deb
}

main () {
    if !isServiceExist bat; then
        install
    fi
}

main
