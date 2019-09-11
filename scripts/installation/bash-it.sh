#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    gitClone https://github.com/Bash-it/bash-it.git ~/.bash_it
    chmod +x ~/.bash_it/install.sh && ~/.bash_it/install.sh --silent --no-modify-config
    source ~/.bashrc
    # bash-it enable plugin fzf tmux direnv

}

main () {
    if ! isServiceExist bash-it ; then
        install
    fi
}

main
