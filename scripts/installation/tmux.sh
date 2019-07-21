#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    apt-fast install --no-install-recommends -y tmux

    # install tmux plugin manager
    if cd ~/.tmux/plugins/tpm ; then
        git -C ~/.tmux/plugins/tpm pull;
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    # install plugins
    ~/.tmux/plugins/tpm/bin/install_plugins
    # install tmuxp & plugins
    # sudo -H pip3 install tmuxp
    sudo pip install tmuxp
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

main () {
    if !isServiceExist tmux; then
        install
    fi
}

main
