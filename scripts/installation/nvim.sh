#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update -y
    apt-fast install --no-install-recommends -y neovim python-neovim python3-neovim
}

config () {
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
}

main() {
    if ! isServiceExist nvim; then
        install
        config
    fi
}

main
