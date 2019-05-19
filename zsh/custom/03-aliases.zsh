#!/usr/bin/env bash

# .zsh files that are put in $ZSH_CUSTOM/{file_name}.zsh will be automatically loaded by OMZ as default
# reference: https://github.com/robbyrussell/oh-my-zsh/issues/5200
# the more the explicitly alias can be the better for readability and history search

# =====================================================================================================================
# LIBRARY
# =====================================================================================================================

# ${(%):-%N} is equivalent of BASH_SOURCE[0] in zsh
sourceBash $(dirname ${(%):-%N})/scripts/base.sh

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

### alias ###
alias llink="la | grep '\->'" # list all link

# ag #
if isServiceExist ag; then
    alias ag="ag -i --pager=less"
fi

# buku - cli bookmark manager (https://github.com/jarun/Buku)
if isServiceExist buku; then
    alias buku="buku --suggest"
    alias buku_sync="buku -d && buku --suggest --ai"
fi

# docker #
if isServiceExist docker; then
    # new kind of alias, better at history search
    alias docker_rm_dangling_images="docker images -qf dangling=true | xargs -r docker rmi"
    alias docker_rm_dangling_volumes="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    function docker_rm_group_images () {
	local pattern="$1"
	cmd="docker images | grep "${pattern}" | awk '{print \$2}' | xargs docker rmi"
        echo ${cmd} && eval ${cmd}
    }
    function docker_rm_group_ps () {
	local pattern="$1"
	cmd="docker ps -a | grep "${pattern}" | awk '{print \$1}' | xargs docker rm"
        echo ${cmd} && eval ${cmd}
    }

    # docker run with interactive mode, image will be deleted after run
    function docker_run_it () {
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
function jenkins_getCLI () {
    local jenkinsUrl="${JENKINS_URL}"
    local outputFile="${1:-${CLI_PATH}/jenkins-cli.jar}"

    [ -z ${jenkinsUrl} ] && { logError "JENKINS_URL env is not exist"; exit 1; }

    curl -X GET "${jenkinsUrl}/jnlpJars/jenkins-cli.jar" -o "${outputFile}" ||
    {
        logError "An error occurred downloading Jenkins CLI to ${outputFile} from ${jenkinsUrl}"
    }
}

function jenkins_cli () {
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
            eval $cmd
            ;;
    esac
}

# nvim "
if isServiceExist nvim; then
    alias nvim_update_plugin="nvim +PlugUpdate +qall"
fi

# pacman #
if isServiceExist pacman; then
    alias pac_install="sudo pacman -S --noconfirm" # install
    alias pac_remove="sudo pacman -R --noconfirm" # remove
    alias pac_search="pacman -Ss" # search
    alias pac_update_system="sudo pacman -Syu --noconfirm" # update system
fi

# tldr #
if isServiceExist tldr; then # debian based
    alias man="tldr"
fi

# xinput
declare builtinKeyboard="AT Translated Set 2 keyboard"
alias xinput_list_keyboard=$'xinput list | grep ${builtinKeyboard}'
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias xinput_list_keyboard_id=$'xinput list | grep ${builtinKeyboard} | awk \'{print $7}\' | cut -c 4-5'
alias xinput_disable_keyboard=$'xinput float $(xinput-list-keyboard-id)'
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput_enable_keyboard=$'xinput reattach $(xinput-list-keyboard-id) 3'

# utils #

# use xdg-open to open any file with default app
# should use & at the end to run the process in background otherwise we cannot continue using the cli
# ex: open file.txt &
if isServiceExist xdg_open; then
    alias open="xdg_open"
fi

### AUTO_CD ###
# zsh will automatically cd to a directory if it is given as command on the command line
# and it is not the name of an actual command. Ex:
# % /usr
# % pwd
# /usr
# reference: https://askubuntu.com/questions/758496/how-to-make-a-permanent-alias-in-oh-my-zsh

# fzf is better

# hash -d dotfiles=~/.dotfiles
# hash -d s-doc=~/.s-doc
# hash -d workspace=~/workspace

