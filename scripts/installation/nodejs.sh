#!/usr/bin/env bash

install () {
    # nvm should be installed already as zsh plugin
    # using nvm to manage node and npm
    nvm install --lts
    nvm use --lts

    # when node is already installed prompt will return exit code error
    # explicit return 0 to avoid that
    return 0
}

install
