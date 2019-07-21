#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base.sh

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

declare ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
declare ZSH_ENV="${ZSH_CUSTOM}/01-env.zsh"

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    apt-fast install --no-install-recommends -y zsh

    local zshCustomPluginsPath="~/.oh-my-zsh/custom/plugins"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    logInfo "installing zsh autosuggestions..."
    gitClone git://github.com/zsh-users/zsh-autosuggestions.git ${zshCustomPluginsPath}/zsh-autosuggestions

    logInfo "installing zsh highlighting..."
    gitClone git://github.com/zsh-users/zsh-syntax-highlighting.git ${zshCustomPluginsPath}/zsh-syntax-highlighting

    # reload current shell to use zsh
    env -i zsh
}

main() {
    if !isServiceExist zsh; then
        install
    fi
}

main
