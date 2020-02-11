#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    # https://github.com/tsenart/vegeta
    local version="$(_git_get_latest_release 'tsenart/vegeta' | cut -c 2-)"
    local downloadFile="vegeta-$version-linux-amd64.tar.gz"
    local url="https://github.com/tsenart/vegeta/releases/download/v$version/$downloadFile"
    local tmpDir="/tmp/vegeta/"
    local localBin="${HOME}/bin"
    local binFile="vegeta"

    curl -L $url --create-dirs -o "$tmpDir/$downloadFile" # download compressed files

    tar -xvf $tmpDir/$downloadFile -C $tmpDir # extract

    chmod +x $tmpDir/$binFile && mv $tmpDir/$binFile $localBin # move binary file to local bin location

    rm -r $tmpDir # remove tmp dir
}

main() {
    install
    # if ! _is_service_exist vegeta; then
    #     install
    # fi
}

main
