#!/usr/bin/env bash

install() {
    echo "... Installing ZSH ..."
    apt-fast install --no-install-recommends -y zsh

    echo "... Installing ZSH Plugin Manager ..." # https://github.com/zplug/zplug
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

    echo "... Changing default shell to zsh ..."
    chsh -s /bin/zsh
}

install
