#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

source $(dirname ${BASH_SOURCE[0]})/b-log/b-log.sh

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

LOG_LEVEL_ALL

# =====================================================================================================================
# LOG FUNCTION
# =====================================================================================================================

echoServiceStatus() {
    local serviceName="${1}"
    local status="${2}"
    case ${status} in
        new)
            NOTICE "Installing ${serviceName}"
            ;;
        installed)
            NOTICE "Already Installed ${serviceName}"
            ;;
        *)
            ERROR "Usage: $0 {new|installed}"
            exit 1
    esac
}

logParamMissing () {
    local paramName="${1}"
    ERROR "Variable ${paramName} is not defined, exiting."
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
