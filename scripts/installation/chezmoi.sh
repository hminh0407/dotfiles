#!/usr/bin/env bash

DOTFILES_REPO="git@gitlab.com:hminh0407/dotfiles.git"

install () {
    local installedPath="./bin/chezmoi"
    local globalPath="/usr/local/bin"

    sh -c "$(curl -fsLS git.io/chezmoi)"
    sudo cp $installedPath $globalPath
}

init() {
    chezmoi init $DOTFILES_REPO
}

main() {
    # install
    # init
    sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply $DOTFILES_REPO
}

main
