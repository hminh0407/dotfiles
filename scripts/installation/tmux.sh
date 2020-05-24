#!/usr/bin/env bash

declare DOTFILES_DIR="$HOME/.dotfiles"
declare DOTFILES_BIN_DIR="$DOTFILES_DIR/bin"
declare DOTFILES_BIN_NVIM="$DOTFILES_BIN_DIR/nvim"

install () {
    # echo "... Installing Tmux ..."
    # sudo apt-fast install --no-install-recommends -y tmux

    echo "... Installing Tmux Plugin Manager ..."
    git cl https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

    echo "... Installing Tmux Plugins ..."
    ~/.tmux/plugins/tpm/bin/install_plugins

    if [ -x "$(command -v pip)" ]; then
        echo "... Installing Tmux Profile Tool tmuxp ..."
        sudo pip install wheel tmuxp
        ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    elif [ -x "$(command -v pip3)" ]; then
        echo "... Installing Tmux Profile Tool tmuxp ..."
        sudo pip3 install wheel tmuxp
        ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    fi
}

install
