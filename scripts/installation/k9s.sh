#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    local version="0.8.4"
    local file="k9s_${version}_Linux_x86_64.tar.gz"
    local url="https://github.com/derailed/k9s/releases/download/$version/$file"
    local tmpDir="/tmp/k9s"
    local localBin="${HOME}/bin"
    local binFile="k9s"

    curl -L $url --create-dirs -o $tmpDir/$file # download compressed files

    tar xvf $tmpDir/$file -C $tmpDir # extract

    sudo mv $tmpDir/$binFile $localBin # move binary file to /usr/bin

    rm -r $tmpDir # remove tmp dir
}

cleanup() {
    sudo rm -r $tmpDir # remove tmp dir
}

main () {
    if ! _is_service_exist k9s; then
        install
        cleanup
    fi
}

main
