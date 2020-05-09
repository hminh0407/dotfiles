#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install() {
    # download source file
    local repo="git@github.com:asdf-vm/asdf.git"
    local folder="$GIT_FOLDER/asdf"

    _git_clone $repo $folder
    cd $folder && git checkout "$(git describe --abbrev=0 --tags)"
        # checkout latest release tag

    # add to cli environment
    local zshrc="$HOME/.zshrc"
    local bashrs="$HOME/.bashrc"

    if [ -f "$bashrc" ]; then
        echo -e "\n. $folder/asdf.sh" >> ~/.bashrc
        # echo -e "\n. $folder/completions/asdf.bash" >> ~/.bashrc
    fi

    if [ -f "$zshrc" ]; then
        echo -e "\n. $folder/asdf.sh" >> ~/.zshrc
        # echo -e "\n. $folder/completions/asdf.bash" >> ~/.zshrc
    fi
}

install
