#!/usr/bin/env bash

declare DOTFILES_DIR="$HOME/.dotfiles"
declare DOTFILES_BIN_DIR="$DOTFILES_DIR/bin"
declare DOTFILES_BIN_NVIM="$DOTFILES_BIN_DIR/nvim"

install () {
    echo "... Installing Tmux ..."
    apt-fast install --no-install-recommends -y tmux

    echo "... Installing Tmux Plugin Manager ..."
    git cl https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

    echo "... Installing Tmux Plugins ..."
    ~/.tmux/plugins/tpm/bin/install_plugins

    echo "... Installing Tmux Profile Tool tmuxp ..."
    sudo pip install wheel tmuxp
    # ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

install
