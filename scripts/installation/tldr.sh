#!/usr/bin/env bash

install () {
    local location="$DOTFILES_BIN_DIR/tldr"
    curl -o $location https://raw.githubusercontent.com/raylee/tldr/master/tldr
    chmod +x $location
}

install
