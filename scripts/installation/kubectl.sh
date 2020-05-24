#!/usr/bin/env bash

declare VERSION="v1.13.10" # https://github.com/kubernetes/kubectl/issues/675
# declare VERSION="v1.12.10-gke.17" # https://github.com/kubernetes/kubectl/issues/675

install () {
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl
    chmod +x ./kubectl && mv ./kubectl $DOTFILES_BIN_DIR/kubectl
}

installKrew() {
    echo "Installing krew..."

    local repo="https://github.com/kubernetes-sigs/krew"
    local version="$(git rp-latest-release $repo | cut -c 2-)"

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
    echo "Initialing kubectl..."
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
