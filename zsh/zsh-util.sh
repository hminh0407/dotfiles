#!/bin/bash

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

declare COMMAND=$1
declare CUSTOM_PLUGINS=~/.oh-my-zsh/custom/plugins

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

getRealPath () { # get the absolute file path
    echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
}

. $(getRealPath "custom/base.sh")

# =====================================================================================================================
# FUNCTIONS
# =====================================================================================================================

install ()
{
    if isServiceExist apt; then # debian based
        echo "installing zsh..."
        sudo apt install -y zsh curl
        sudo apt -y autoremove
    elif isServiceExist pacman; then # arch based
        echo "installing zsh..."
        sudo pacman -S zsh --noconfirm --needed
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # check if link exist and not broken
    if [ -L ~/.zshrc ] && [ -e ~/.zshrc ] ; then
        echo "zsh onfig already exist"
    else
        mv -f ~/.zshrc ~/.zshrc.bk
    fi

    # zsh config files
    ln -sfn $(getRealPath "zshrc")    ${HOME}/.zshrc
    ln -sfn $(getRealPath "custom")/* ${HOME}/.oh-my-zsh/custom/

    # install auto suggestion
    if cd ${CUSTOM_PLUGINS}/zsh-autosuggestions ; then
        git -C ${CUSTOM_PLUGINS}/zsh-autosuggestions pull;
    else
        echo "installing zsh auto suggestion..."
        git clone git://github.com/zsh-users/zsh-autosuggestions ${CUSTOM_PLUGINS}/zsh-autosuggestions;
    fi

    # install syntax highlighting
    if cd ${CUSTOM_PLUGINS}/zsh-syntax-highlighting ; then
        git -C ${CUSTOM_PLUGINS}/zsh-syntax-highlighting pull;
    else
        echo "installing zsh highlighting..."
        git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ${CUSTOM_PLUGINS}/zsh-syntax-highlighting;
    fi

    # reload current shell to use zsh
    env -i zsh
}

