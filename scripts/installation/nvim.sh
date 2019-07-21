#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    sudo apt-add-repository -y ppa:neovim-ppa/stable
    sudo apt-get update -y

    apt-fast install --no-install-recommends -y neovim
}

config () {
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor

    # install tools used for plugins
    sudo npm install -g js-beautify # for Autoformat to format json and js file
}

main() {
    if !isServiceExist nvim; then
        install
        config
    fi
}

main
