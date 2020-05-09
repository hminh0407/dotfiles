#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

declare VERSION="v1.13.10" # https://github.com/kubernetes/kubectl/issues/675
# declare VERSION="v1.12.10-gke.17" # https://github.com/kubernetes/kubectl/issues/675

install () {
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl
    chmod +x ./kubectl && mv ./kubectl $CUSTOM_SCRIPTS/kubectl
}

installKrew() {
    # https://github.com/kubernetes-sigs/krew/
    local version="$(_git_get_latest_release "kubernetes-sigs/krew" | cut -c 2-)"

    set -x; cd "$(mktemp -d)"
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v$version/krew.{tar.gz,yaml}"
    tar zxvf krew.tar.gz

    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64"
    "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz
    "$KREW" update
}

installKrewPlugins() {
    kubectl krew install resource-capacity
}

config() { # auto config kubectl (required gcloud init first)
    local clusters=( $(gcloud container clusters list --format='table[no-heading](name)') )

    gcloud config configurations activate default # activate default gcloud config
    if [ -n "$clusters" ] && [ ${#clusters[@]} -gt 0 ]; then
        # generate config for each cluster
        for cluster in ${clusters[@]}; do
            gcloud container clusters get-credentials $cluster
        done
    fi
}

main () {
    install
    config
    installKrew # kubectl package manager
}

main
