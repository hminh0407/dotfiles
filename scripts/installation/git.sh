#!/usr/bin/env bash

install () {
    echo "... Installing git ..."
    apt-fast install --no-install-recommends -y git

    echo "... Installing tig ..."
    apt-fast install --no-install-recommends -y tig
}

install
