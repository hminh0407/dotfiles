#!/usr/bin/env bash

install () {
    local localBin="$DOTFILES_BIN_DIR"

    local version="1.6.0"
    local zipFilename="packer_${version}_linux_amd64.zip"
    local unzippedFolderName="packer"

    local downloadLink="https://releases.hashicorp.com/packer/${version}/$zipFilename"

    # ---

    wget $downloadLink

    unzip $zipFilename

    mv $unzippedFolderName $localBin
}

install
