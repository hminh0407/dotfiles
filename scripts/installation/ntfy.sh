#!/usr/bin/env bash

install () {
    apt-fast install --no-install-recommends -y python-dbus
    sudo pip install ntfy
}

install
