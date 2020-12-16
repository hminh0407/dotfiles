#!/usr/bin/env bash

GO_VERSION="1.15.6"

install () {
    echo "... Installing GO version $GO_VERSION ..."

    local repo="https://github.com/golang/go"
    local version="$GO_VERSION"

    local localBin="$DOTFILES_BIN_DIR"

    local download_tmp_folder="$(mktemp -d)"
    local download_file="go$version.linux-amd64.tar.gz"
    local download_url="https://golang.org/dl/go$version.linux-amd64.tar.gz"
    local download_file_path="$download_tmp_folder/$download_file"

    echo "creating tmp folder $download_tmp_folder ..."

    echo $download_file_path
    echo $download_url

    wget -qO $download_file_path $download_url
    tar -C $localBin -xzf $download_file_path

    rm -r $download_tmp_folder
}

install
