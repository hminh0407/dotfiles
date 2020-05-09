#!/usr/bin/env bash

install () {
    # Add the Cloud SDK distribution URI as a package source
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

    # Import the Google Cloud Platform public key
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

    # Update the package list and install the Cloud SDK
    sudo apt-get update && apt-fast install --no-install-recommends -y google-cloud-sdk
}

install
