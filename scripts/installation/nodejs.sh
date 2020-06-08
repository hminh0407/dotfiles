#!/usr/bin/env bash

install () {
    local NODE_VERSION="v10" # lts v10

    # nvm should be installed already as zsh plugin
    # using nvm to manage node and npm
    nvm install $NODE_VERSION
    nvm alias default $NODE_VERSION
    nvm use default

    # # when node is already installed prompt will return exit code error
    # # explicit return 0 to avoid that
    return 0
}

install
