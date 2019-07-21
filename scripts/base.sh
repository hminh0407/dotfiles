#!/usr/bin/env bash

source $(dirname ${BASH_SOURCE[0]})/log.sh

ENV_LOCATION="${HOME}/.oh-my-zsh/custom/01-env.zsh"

# =====================================================================================================================

appendToFileIfNotExist () {
    [ -z "$1" ] && { logParamMissing "line"; exit 1; }
    [ -z "$2" ] && { logParamMissing "file"; exit 1; }

    local line="$1"
    local file="$2"
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

echoServiceStatus () {
    local serviceName="${1}"
    local status="${2}"

    case ${status} in
        new)
            logInfo "Installing ${serviceName}"
            ;;
        installed)
            logInfo "Already Installed ${serviceName}"
            ;;
        *)
            logError "Usage: $0 {new|installed}"
            exit 1
    esac
}

logParamMissing () {
    local paramName="${1}"
    logError "Parameter ${paramName} is not exist, exiting."
}

isServiceExist () {
    [ -z "$1" ] && { logParamMissing "service"; exit 1; }
    local service="$1"
    # check if service exist and not an alias by checking its execute file location
    if service_loc="$(type -p "${service}")" || [[ -z $service_loc ]]; then
        return
    fi
    # a proper way to use bash function that return boolean: https://stackoverflow.com/a/43840545
    false
}

# clone git if not exist, pull latest code if exist
gitClone () {
    [ -z "$1" ] && { logParamMissing "repo"; exit 1; }
    [ -z "$2" ] && { logParamMissing "localRepo"; exit 1; }
    local repo="${1}"
    local localRepo="${2}"

    git clone ${repo} ${localRepo} 2> /dev/null || git -C ${localRepo} pull;
}
