#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

install () {
    apt-fast install --no-install-recommends -y tmux python-pip

    # install tmux plugin manager
    _git_clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm
    # install plugins
    ~/.tmux/plugins/tpm/bin/install_plugins
    # install tmuxp & plugins
    sudo pip install wheel tmuxp
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

main () {
    if ! _is_service_exist tmux; then
        install
    fi
}

main
