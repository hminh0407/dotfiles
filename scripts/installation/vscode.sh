#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

install () {
    apt-fast install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update && apt-fast install code
}

main () {
    if ! isServiceExist code ; then
        install
    fi
}

main
