#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    local repo="sharkdp/bat"
    local version="$(_git_get_latest_release $repo | cut -c 2-)" # remove 'v'
    local location="$CUSTOM_SCRIPTS/bat.deb"
    local link="https://github.com/sharkdp/bat/releases/download/v$version/bat_$version_amd64.deb"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist bat; then
        install
    fi
}

main
