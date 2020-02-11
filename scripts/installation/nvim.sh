#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install() {
    local repo="neovim/neovim"
    local version="$(_git_get_latest_release $repo)"
    local location="$CUSTOM_SCRIPTS/nvim"
    local link="https://github.com/$repo/releases/download/$version/nvim.appimage"

    wget -qO $location $link && chmod +x $location

    sudo pip install pynvim
}

# install () {
#     sudo add-apt-repository -y ppa:neovim-ppa/stable
#     sudo apt-get update -y
#     apt-fast install --no-install-recommends -y neovim python-neovim python3-neovim ripgrep
# }

config () {
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --install /usr/bin/vi vi $CUSTOM_SCRIPTS/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/editor editor $CUSTOM_SCRIPTS/nvim 60
    sudo update-alternatives --config editor
}

plugin() {
    # setup environment for vim plugins
    apt-fast install --no-install-recommends -y nodejs npm
    sudo npm install -g bash-language-server yarn

    # make vimwiki works with tagbar
    # local location="$CUSTOM_SCRIPTS/vwtags.py"
    # local link="https://raw.githubusercontent.com/vimwiki/utils/master/vwtags.py"

    # config for markdown
    local location="$CUSTOM_SCRIPTS/markdown2ctags.py"
    local link="https://github.com/jszakmeister/markdown2ctags/blob/master/markdown2ctags.py"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist nvim; then
        install
        config
        plugin
    fi
}

main

