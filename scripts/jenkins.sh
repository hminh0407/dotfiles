#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/base/functions.sh

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

# ENVIRONMENT VARIABLES NEEDED
# * JENKINS_URL
# * JENKINS_USER_ID
# * JENKINS_API_TOKEN

declare LOCAL_BIN=/usr/local/bin
# declare LOCAL_BIN=${HOME}/bin

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

# Download Jenkins CLI from a Jenkins server
jenkins_getCLI () {
    local jenkinsUrl="${JENKINS_URL}"
    local outputFile="${1:-${CLI_PATH}/jenkins-cli.jar}"

    [ -z ${jenkinsUrl} ] && { logError "JENKINS_URL env is not exist"; exit 1; }

    curl -X GET "${jenkinsUrl}/jnlpJars/jenkins-cli.jar" -o "${outputFile}" ||
    {
        logError "An error occurred downloading Jenkins CLI to ${outputFile} from ${jenkinsUrl}"
    }
}

jenkins_cli () {
    local debug="${DEBUG:-''}"
    local dryRun="${DRY_RUN:-''}"
    local jenkinsUrl="${JENKINS_URL}"
    local jenkinsUser="${JENKINS_USER}"
    local jenkinsToken="${JENKINS_TOKEN}"
    local jenkinsFullCommand="$@"
    local jenkinsCommand="$1"

    [ -z ${jenkinsUrl}   ] && { logError "JENKINS_URL env is not exist";   exit 1; }
    [ -z ${jenkinsUser}  ] && { logError "JENKINS_USER env is not exist";  exit 1; }
    [ -z ${jenkinsToken} ] && { logError "JENKINS_TOKEN env is not exist"; exit 1; }

    case $jenkinsCommand in
        # make the function use readonly command
        create*|remove*|delete*|update*)
            logWarn "For safety we should only run readonly command";
            ;;
        *)
            local cmd="java -jar ${CLI_PATH}/jenkins-cli.jar -s $jenkinsUrl -http -auth $jenkinsUser:$jenkinsToken $jenkinsFullCommand"

            if [ $debug = "true" ]; then
                echo $cmd # only use for debug purpose
            fi

            if [ ! $dryRun = "true" ]; then
                eval $cmd
            fi

            sendNotification "jenkins_cli $jenkinsFullCommand completed"
            ;;
    esac
}
