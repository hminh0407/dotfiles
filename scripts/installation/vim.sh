#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt-get update -y
    apt-fast install --no-install-recommends -y vim-gtk3
        # install gui version of vim for clipboard support
}

config () {
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim.gtk3 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/vim.gtk3 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim.gtk3 60
    sudo update-alternatives --config editor
}

plugin() {
    # install vim-plug (plugin manager)
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # setup environment for vim plugins
    apt-fast install --no-install-recommends -y nodejs npm
    sudo npm install -g bash-language-server

    # make vimwiki works with tagbar
    # config for vimwiki
    # local location="$CUSTOM_SCRIPTS/vwtags.py"
    # local link="https://raw.githubusercontent.com/vimwiki/utils/master/vwtags.py"

    # config for markdown
    local location="$CUSTOM_SCRIPTS/markdown2ctags.py"
    local link="https://github.com/jszakmeister/markdown2ctags/blob/master/markdown2ctags.py"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist vim; then
        install
        config
        plugin
    fi
}

main

