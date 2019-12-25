#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    local location="$CUSTOM_SCRIPTS/youtube-dl"
    local link="https://yt-dl.org/downloads/latest/youtube-dl"

    wget -qO $location $link && chmod +x $location
}

main() {
    if ! _is_service_exist youtube-dl; then
        install
    fi
}

main
