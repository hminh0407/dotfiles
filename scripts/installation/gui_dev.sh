#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    # install apt packages
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

    # sudo apt update
    apt-fast install --no-install-recommends -y \
        dbeaver-ce meld

    # install snap packages
    snap install postman
    snap install intellij-idea-community hub --classic
    sudo apt autoremove # clear installation cache
}

main () {
    if [ ! "$GUI_DEV_INSTALLED" == "true" ]; then
        install
    fi

    # mark as already installed
    local line="export GUI_DEV_INSTALLED=true"
    local file="$ENV_LOCATION"
    appendToFileIfNotExist "$line" "$file"
}

main
