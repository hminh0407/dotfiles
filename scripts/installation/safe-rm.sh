#!/usr/bin/env bash

declare BASEDIR=$(dirname ${BASH_SOURCE[0]})
. "$BASEDIR/../base/functions.sh"

install () {
    local version="0.12"
    local file="safe-rm-$version.tar.gz"
    local url="https://launchpad.net/safe-rm/trunk/$version/+download/$file"
    local tmpDir="/tmp/safe-rm"
    local localBin="${HOME}/bin"
    local binFile="safe-rm"

    curl -L $url --create-dirs -o $tmpDir/$file # download compressed files

    tar xvf $tmpDir/$file -C $tmpDir # extract

    sudo mv $tmpDir/$binFile $localBin # move binary file to /usr/bin

    rm -r $tmpDir # remove tmp dir
}

main () {
    if ! _is_service_exist safe-rm; then
        install
    fi
}

main
