#!/usr/bin/env bash

install () {
    local location="$DOTFILES_BIN_DIR/cloud_sql_proxy"
    local link="https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64"

    wget -qO $location $link && chmod +x $location
}

install
