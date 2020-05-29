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
    local version="$(git rp-latest-release $repo)"
    local url="$repo/releases/download/$version/krew.{tar.gz,yaml}"
    echo $url

    local tmpFolder="$(mktemp -d)"
    set -x; cd $tmpFolder
    curl -fsSLO "$url"
    tar zxvf krew.tar.gz

    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64"
    "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz
    "$KREW" update
    # also need to update PATH environment variable, which taken care in zsh/zshrc.d/04-integration.zsh

    rm -r $tmpFolder
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
    installKrewPlugins
}

main
