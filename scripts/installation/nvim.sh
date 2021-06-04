#!/usr/bin/env bash
set -euo pipefail

installAppImage() {
    echo "... Installing Nvim ..."

    local repo="https://github.com/neovim/neovim"
    local version="$(git rp-latest-release $repo)"
    # local location="$CUSTOM_SCRIPTS/nvim"
    local location="$DOTFILES_BIN_NVIM"
    local link="$repo/releases/download/$version/nvim.appimage"
    local file="$(basename $link)"

    curl -LO $link && mv $file $location && chmod u+x $location

    echo "... Configuring Nvim ..."
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --auto --install /usr/bin/vi vi $DOTFILES_BIN_NVIM 60
    sudo update-alternatives --auto --config vi
    sudo update-alternatives --auto --install /usr/bin/editor editor $DOTFILES_BIN_NVIM 60
    sudo update-alternatives --auto --config editor

    # sudo pip install pynvim # install python support
    apt-fast install --no-install-recommends -y python3-neovim
}

installFromSource() {
    echo "... Installing NVIM prerequisite ..."
    apt-fast install --no-install-recommends -y \
        make cmake build-essential pkg-config libtool-bin gettext \
        gperf luajit luarocks libuv1-dev libluajit-5.1-dev libunibilium-dev libmsgpack-dev \
        libtermkey-dev libvterm-dev libutf8proc-dev \
        python3-neovim

    sudo luarocks build mpack
    sudo luarocks build lpeg
    sudo luarocks build inspect

    echo "... Building NVIM from source ..."
    git cl "https://github.com/neovim/neovim.git" $DOTFILES_TMP_DIR/neovim
    cd $DOTFILES_TMP_DIR/neovim
    # git checkout stable
    make CMAKE_BUILD_TYPE=Release
    sudo make install
}

installFromApt() {
    echo "... Installing Nvim ..."
    apt-fast install --no-install-recommends -y neovim
}

config() {
    echo "... Configuring Vim ..."
    # use Neovim for some (or all) of the editor alternatives, use the following commands
    sudo update-alternatives --install /usr/bin/vi vi $(which nvim) 60
    sudo update-alternatives --auto vi
    sudo update-alternatives --install /usr/bin/editor editor $(which nvim) 60
    sudo update-alternatives --auto editor

    # setup custom viminfo
    mkdir -p ~/.vim/files/info

    echo "... Installing Vim Plugins ..."
    nvim -E -c ':PlugInstall!' -c qa

    # install essential packages for vim support
    apt-fast install --no-install-recommends -y python3-neovim

    # instal plantweb to support plantuml render
    sudo pip3 install plantweb
}

main() {
    installFromApt
    config
}

main
