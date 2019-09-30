#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/env.sh
. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    local location="$CUSTOM_SCRIPTS/tldr"
    curl -o $location https://raw.githubusercontent.com/raylee/tldr/master/tldr
    chmod +x $location
}

main () {
    if ! _is_service_exist tldr; then
        install
    fi
}

main
