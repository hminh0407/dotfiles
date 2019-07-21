#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    # install apt packages
    apt-fast install --no-install-recommends -y \
        nautilus-dropbox
}

main () {
    if [ ! "$GUI_GENERAL_INSTALLED" == "true" ]; then
        install
    fi

    # mark as already installed
    local line="export GUI_GENERAL_INSTALLED=true"
    local file="$ENV_LOCATION"
    appendToFileIfNotExist "$line" "$file"
}

main
