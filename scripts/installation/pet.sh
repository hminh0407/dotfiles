#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

declare PET_VERSION="0.3.2"

install () {
    wget https://github.com/knqyf263/pet/releases/download/v${PET_VERSION}/pet_${PET_VERSION}_linux_amd64.deb \
        -O /tmp/pet_${PET_VERSION}_linux_amd64.deb
    sudo dpkg -i /tmp/pet_${PET_VERSION}_linux_amd64.deb

    # after copy config file, manual update config access_token
    yes | mkdir -p ~/.config/pet && cp -f ~/workspace/dotfiles/pet/config.toml ~/.config/pet/config.toml
}

main () {
    if !isServiceExist pet; then
        install
    fi
}

main
