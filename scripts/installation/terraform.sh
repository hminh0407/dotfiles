#!/usr/bin/env bash

install () {
    local localBin="$DOTFILES_BIN_DIR"

    local version="0.14.5"
    local zipFilename="terraform_${version}_linux_amd64.zip"
    local unzippedFolderName="terraform"

    local downloadLink="https://releases.hashicorp.com/terraform/${version}/$zipFilename"

    # ---

    wget $downloadLink

    unzip $zipFilename

    mv $unzippedFolderName $localBin
}

install
