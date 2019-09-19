#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    apt-fast install --no-install-recommends -y tmux python-pip

    # install tmux plugin manager
    gitClone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm
    # install plugins
    ~/.tmux/plugins/tpm/bin/install_plugins
    # install tmuxp & plugins
    sudo pip install tmuxp
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

main () {
    # if ! isServiceExist tmux; then
        install
    # fi
}

main
