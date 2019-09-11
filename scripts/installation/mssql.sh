#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base.sh

install () {
    # install sql server cmd tools for Linux to import & export data
    # https://www.easysoft.com/products/data_access/odbc-sql-server-driver/bulk-copy.html
    # curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    # curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
    # sudo apt-get update
    apt-fast install --no-install-recommends -y libodbc1 unixodbc mssql-tools

    local line="export PATH=\"$PATH:/opt/mssql-tools/bin\""
    local file=$ENV_LOCATION
    appendToFileIfNotExist "$line" $file
    source ~/.zshrc

    # install mssql-cli client
    sudo pip install mssql-cli
}

main () {
    if ! isServiceExist mssql-cli; then
        install
    fi
}

main
