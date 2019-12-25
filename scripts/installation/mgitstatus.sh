#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    local location="$CUSTOM_SCRIPTS/mgst"
    local link="https://raw.githubusercontent.com/fboender/multi-git-status/master/mgitstatus"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist mgst; then
        install
    fi
}

main
