#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    apt-fast install --no-install-recommends -y zsh
    # Get prezto
    _git_clone https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim

    # install plugin manager
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

    # # Backup zsh config if it exists
    if [ -f ~/.zshrc ]; then
           mv ~/.zshrc ~/.zshrc.backup
    fi

    # run this manually as dotbot does not support interactive command
    # chsh -s $(which zsh)
}

main () {
    if ! _is_service_exist zsh; then
        install
    fi
}

main
