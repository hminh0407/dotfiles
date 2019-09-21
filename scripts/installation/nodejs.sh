#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    # using nvm to manage node and npm
    # nvm is used as oh-my-zsh plugin (zsh-nvm)
    nvm install --lts
    nvm use --lts
}

main () {
    if ! _is_service_exist node; then
        install
    fi
}

main
