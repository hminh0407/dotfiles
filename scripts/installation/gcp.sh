#!/usr/bin/env bash
installSqlProxy() {
    echo "Installing Cloud SQL Proxy..."

    local location="$DOTFILES_BIN_DIR/cloud_sql_proxy"
    local link="https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64"

    wget -qO $location $link && chmod +x $location
}

install () {
    # Add the Cloud SDK distribution URI as a package source
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

    # Import the Google Cloud Platform public key
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

    # Update the package list and install the Cloud SDK
    sudo apt-get update && apt-fast install --no-install-recommends -y google-cloud-sdk

    # Install Cloud SQL Proxy
    installSqlProxy
}

install
