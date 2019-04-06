#!/usr/bin/env bash

# .zsh files that are put in $ZSH_CUSTOM/{file_name}.zsh will be automatically loaded by OMZ as default
# reference: https://github.com/robbyrussell/oh-my-zsh/issues/5200
# the more the explicitly alias can be the better for readability and history search

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

### utils ###
# check if a shell service exist
isServiceExist () {
    local service="$1"
    # check if service exist and not an alias by checking its execute file location
    if service_loc="$(type -p "${service}")" || [[ -z $service_loc ]]; then
        return
    fi
    # a proper way to use bash function that return boolean: https://stackoverflow.com/a/43840545
    false
}

### alias ###
alias llink="la | grep '\->'" # list all link

# ag #
if isServiceExist ag; then
    alias ag="ag -i --pager=less"
fi

# buku - cli bookmark manager (https://github.com/jarun/Buku)
if isServiceExist buku; then
    alias buku="buku --suggest"
    alias buku-sync="buku -d && buku --suggest --ai"
fi

# docker #
if isServiceExist docker; then
    # new kind of alias, better at history search
    alias docker-rm-dangling-images="docker images -qf dangling=true | xargs -r docker rmi"
    alias docker-rm-dangling-volumes="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    docker-rm-group-images () {
	local pattern="$1"
	cmd="docker images | grep "${pattern}" | awk '{print \$1}' | xargs docker rmi"
        echo ${cmd} && eval ${cmd}
    }
    docker-rm-group-ps () {
	local pattern="$1"
	cmd="docker ps -a | grep "${pattern}" | awk '{print \$1}' | xargs docker rm"
        echo ${cmd} && eval ${cmd}
    }

    # docker run with interactive mode, image will be deleted after run
    docker-run-it () {
        local image="$1" entrypoint="${2:=/bin/sh}"
        local tmpName="${1//[:.]/_}" # replace ':' with '_'
        cmd="docker run -it --rm --name '${tmpName}' --entrypoint ${entrypoint} "${@:3}" ${image}"
        echo ${cmd} && eval ${cmd}
    }
fi

if isServiceExist docker-compose; then
    alias compose="docker-compose"
    alias compose-build="docker-compose build --force-rm"
    alias compose-up="docker-compose up -d --build"
fi

if isServiceExist nvim; then
    alias nvim-update-plugin="nvim +PlugUpdate +qall"
fi

# pacman #
if isServiceExist pacman; then
    alias pac-install="sudo pacman -S --noconfirm" # install
    alias pac-remove="sudo pacman -R --noconfirm" # remove
    alias pac-search="pacman -Ss" # search
    alias pac-update_system="sudo pacman -Syu --noconfirm" # update system
fi

# tldr #
if isServiceExist tldr; then # debian based
    alias man="tldr"
fi

# xinput
declare builtinKeyboard="AT Translated Set 2 keyboard"
alias xinput-list-keyboard=$'xinput list | grep ${builtinKeyboard}'
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias xinput-list-keyboard-id=$'xinput list | grep ${builtinKeyboard} | awk \'{print $7}\' | cut -c 4-5'
alias xinput-disable-keyboard=$'xinput float $(xinput-list-keyboard-id)'
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput-enable-keyboard=$'xinput reattach $(xinput-list-keyboard-id) 3'

# utils #

# use xdg-open to open any file with default app
# should use & at the end to run the process in background otherwise we cannot continue using the cli
# ex: open file.txt &
if isServiceExist xdg-open; then
    alias open="xdg-open"
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

