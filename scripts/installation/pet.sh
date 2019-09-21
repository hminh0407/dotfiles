#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

declare PET_VERSION="0.3.6"
declare DOTFILES="${HOME}/dotfiles"

install () {
    wget https://github.com/knqyf263/pet/releases/download/v${PET_VERSION}/pet_${PET_VERSION}_linux_amd64.deb -O /tmp/pet_${PET_VERSION}_linux_amd64.deb
    sudo dpkg -i /tmp/pet_${PET_VERSION}_linux_amd64.deb
}

main () {
    if ! _is_service_exist pet; then
        install
    fi
}

main
