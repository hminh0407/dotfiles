#!/usr/bin/env bash

# .zsh files that are put in $ZSH_CUSTOM/{file_name}.zsh will be automatically loaded by OMZ as default
# reference: https://github.com/robbyrussell/oh-my-zsh/issues/5200
# the more the explicitly alias can be the better for readability and history search

# =====================================================================================================================
# LIBRARY
# =====================================================================================================================

# ${(%):-%N} is equivalent of BASH_SOURCE[0] in zsh
. $(dirname ${BASH_SOURCE[0]})/../../scripts/base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

### alias ###
alias apt-get="apt-fast"
alias apt-ins="apt-fast install --no-install-recommends -y"
alias llink="la | grep '\->'" # list all link

# ag #
if isServiceExist ag; then
    alias ag="ag -i --pager=less"
fi

# docker #
if isServiceExist docker; then
    # new kind of alias, better at history search
    alias docker_rm_dangling_images="docker images -qf dangling=true | xargs -r docker rmi"
    alias docker_rm_dangling_volumes="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    alias docker_stop_all="docker stop $(docker ps -q)"

    docker_rm_all_ps () {
        docker rm -fv $(docker ps -aq)
    }

    docker_rm_group_images () {
	local pattern="$1"
	cmd="docker images | grep "${pattern}" | awk '{print \$2}' | xargs docker rmi"
        echo ${cmd} && eval ${cmd}
    }
    docker_rm_group_ps () {
	local pattern="$1"
	cmd="docker ps -a | grep "${pattern}" | awk '{print \$1}' | xargs docker rm"
        echo ${cmd} && eval ${cmd}
    }

    # docker run with interactive mode, image will be deleted after run
    docker_run_it () {
        local image="$1" entrypoint="${2:=/bin/sh}"
        local tmpName="${1//[:.]/_}" # replace ':' with '_'
        cmd="docker run -it --rm --name '${tmpName}' --entrypoint ${entrypoint} "${@:3}" ${image}"
        echo ${cmd} && eval ${cmd}
    }
fi

if isServiceExist docker-compose; then
    alias compose="docker-compose"
    alias compose_build="docker-compose build --force-rm"
    alias compose_up="docker-compose up -d --build"
fi

# jenkin #
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

# xinput
declare builtinKeyboard="AT Translated Set 2 keyboard"
alias xinput_list_keyboard=$'xinput list | grep ${builtinKeyboard}'
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias xinput_list_keyboard_id=$'xinput list | grep ${builtinKeyboard} | awk \'{print $7}\' | cut -c 4-5'
alias xinput_disable_keyboard=$'xinput float $(xinput_list_keyboard_id)'
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput_enable_keyboard=$'xinput reattach $(xinput_list_keyboard_id) 3'

# use xdg-open to open any file with default app
# should use & at the end to run the process in background otherwise we cannot continue using the cli
# ex: open file.txt &
if isServiceExist xdg-open; then
    alias open="xdg-open"
fi
