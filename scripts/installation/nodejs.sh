#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    # using nvm to manage node and npm
    # nvm is used as oh-my-zsh plugin (zsh-nvm)
    nvm install --lts
    nvm use --lts
}

main () {
    if !isServiceExist node; then
        install
    fi
}

main
