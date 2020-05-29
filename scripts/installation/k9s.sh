#!/usr/bin/env bash

install () {
    echo "... Installing k9s ..."

    local repo="https://github.com/derailed/k9s"
    local version="$(git rp-latest-release $repo)"

    local file="k9s_Linux_x86_64.tar.gz"
    local url="$repo/releases/download/$version/$file"
    local tmpDir="/tmp/k9s"
    local localBin="$DOTFILES_BIN_DIR"
    local binFile="k9s"

    # echo $url
    mkdir -p $tmpDir
    # curl -L $url --create-dirs -o "$tmpDir/$file" # download compressed files
    wget -qO "$tmpDir/$file" $url

    tar xvf $tmpDir/$file -C $tmpDir # extract

    chmod +x $tmpDir/$binFile
    sudo mv $tmpDir/$binFile $localBin # move binary file to /usr/bin

    sudo rm -r $tmpDir # remove tmp dir
}

install
