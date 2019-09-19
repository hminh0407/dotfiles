#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/base.sh

install () {
    local version="0.4.3"
    local downloadFile="popeye_${version}_Linux_x86_64.tar.gz"
    local url="https://github.com/derailed/popeye/releases/download/v$version/$downloadFile"
    local tmpDir="/tmp/popeye/"
    local localBin="${HOME}/bin"
    local binFile="popeye"

    curl -L $url --create-dirs -o "$tmpDir/$downloadFile" # download compressed files

    tar xvf $tmpDir/$downloadFile -C $tmpDir # extract

    mv $tmpDir/$binFile $localBin # move binary file to local bin location

    rm -r $tmpDir # remove tmp dir

}

main () {
    if ! isServiceExist popeye; then
        install
    fi
}

main
