#!/usr/bin/env bash

install() {
    local repo="https://github.com/browsh-org/browsh"
    local version="$(git rp-latest-release $repo)"
    local versionWithoutV="${version:1}"
    local file="browsh_${versionWithoutV}_linux_amd64.deb"
    local url="$repo/releases/download/$version/$file"

    wget $url
    sudo apt install ./$file
    rm $file
}

install
