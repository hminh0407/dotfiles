#!/usr/bin/env bash

install () {
    sudo apt-fast install --no-install-recommends -y python-dbus
    sudo pip install ntfy
}

install
