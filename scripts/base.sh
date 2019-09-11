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

logParamMissing () {
    local paramName="${1}"
    logError "Parameter ${paramName} is not exist, exiting."
}

isServiceExist () {
    # https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
    local service="${1}"
    [ -x "$(command -v $service)" ]
}

# clone git if not exist, pull latest code if exist
gitClone () {
    [ -z "$1" ] && { logParamMissing "repo"; exit 1; }
    [ -z "$2" ] && { logParamMissing "localRepo"; exit 1; }
    local repo="${1}"
    local localRepo="${2}"

    # git clone ${repo} ${localRepo} 2> /dev/null || git -C ${localRepo} pull
    git -C ${localRepo} pull || git clone --depth=1 ${repo} ${localRepo}
}
