#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    local location="$CUSTOM_SCRIPTS/cloud_sql_proxy"
    local link="https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist cloud_sql_proxy; then
        install
    fi
}

main
