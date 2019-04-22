#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/base.sh

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

# ENVIRONMENT VARIABLES NEEDED
# * JENKINS_URL
# * JENKINS_USER_ID
# * JENKINS_API_TOKEN

declare LOCAL_BIN=/usr/local/bin
# declare LOCAL_BIN=${HOME}/bin

LOG_LEVEL_ALL # set log level

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

function jenkins_getCLI () {
    local outputFile="${1:-${LOCAL_BIN}/jenkins-cli.jar}"
    curl -X GET "${JENKINS_URL}/jnlpJars/jenkins-cli.jar" -o "${outputFile}" ||
    ERROR "An error occurred downloading Jenkins CLI to ${outputFile} from ${JENKINS_URL}"
}
