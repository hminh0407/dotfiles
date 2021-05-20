#!/usr/bin/env bash

declare VERSION="v1.20.1" # https://github.com/kubernetes/kubectl/issues/675
# declare VERSION="v1.15.12" # https://github.com/kubernetes/kubectl/issues/675
# declare VERSION="v1.12.10-gke.17" # https://github.com/kubernetes/kubectl/issues/675

install () {
    # to get the latest version: https://storage.googleapis.com/kubernetes-release/release/stable.txt
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

    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" && "$KREW" install krew
    # also need to update PATH environment variable, which taken care in zsh/zshrc.d/04-integration.zsh

    rm -r $tmpFolder
}

installKrewPlugins() {
    kubectl krew install ctx
    kubectl krew install ns
    kubectl krew install resource-capacity
}

config() { # auto config kubectl (required gcloud init first)
    echo "Initialing kubectl..."
    local clusters=( $(gcloud container clusters list --format='table[no-heading](name)') )

    gcloud config configurations activate default # activate default gcloud config

    _clear_kubectl_contexts # clear context to setup latest contexts from server

    if [ -n "$clusters" ] && [ ${#clusters[@]} -gt 0 ]; then
        # generate config for each cluster
        for cluster in ${clusters[@]}; do
            if gcloud container clusters get-credentials $cluster; then
                local kubectl_context="$(kubectl config current-context)"
                # rename context to shorter name
                kubectl config rename-context $kubectl_context $cluster
            fi
        done
    fi
}

_clear_kubectl_contexts() {
    kubectl config view -o jsonpath='{range .contexts[*]}{"\n"}{.name}' | xargs -I {} kubectl config delete-context {}
}

main () {
    install
    config
    installKrew # kubectl package manager
    installKrewPlugins
}

main
