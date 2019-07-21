#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    # install apt packages
    apt-fast install --no-install-recommends -y \
        python-dev

    # install pip tools
    sudo pip install mycli pgcli
}

main () {
    if [ ! "$PYTHON_INSTALLED" == "true" ]; then
        install
    fi

    # mark as already installed
    local line="export PYTHON_INSTALLED=true"
    local file="$ENV_LOCATION"
    appendToFileIfNotExist "$line" "$file"
}

main
