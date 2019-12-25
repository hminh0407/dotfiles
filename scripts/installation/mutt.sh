#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

install () {
    apt-fast install --no-install-recommends -y pass isync

    local repo="git@github.com:LukeSmithxyz/mutt-wizard.git"
    local repo_name="LukeSmithxyz/mutt-wizard"
    local git_folder="$TMP_FOLDER/mutt-wizzard"

    _git_clone $repo $git_folder
    ( cd $git_folder && make install )
}

config () {
    pass init
}

main() {
    if ! _is_service_exist mw; then
        install
    fi
}

main
