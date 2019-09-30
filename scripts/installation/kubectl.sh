#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh
. $(dirname ${BASH_SOURCE[0]})/../base/env.sh

declare VERSION="v1.13.10" # https://github.com/kubernetes/kubectl/issues/675

install () {
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl
    chmod +x ./kubectl && mv ./kubectl $CUSTOM_SCRIPTS/kubectl
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
    if ! _is_service_exist kubectl; then
        install
        config
    fi
}

main
