# Store all aliases

# Pattern for alias naming
#
# pattern: <app><feature> - alias with no action is mean to show information
# example: <docker><process>
# example: dkps="docker ps -a" - list running docker container
#
# pattern: replace current command to add more feature
# example: ping='ping -c 4'

# common #
alias chown='chown --preserve-root' # safety
alias chmod='chmod --preserve-root' # safety
alias chgrp='chgrp --preserve-root' # safety
alias cpu='lscpu'
alias mv="mv -pv"
alias nowtime='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias now='date +"%d-%m-%Y %T"'
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 4'
alias ram="sudo lshw -short -C memory"
alias wget="wget -c"

### alias ###
if isServiceExist apt-fast; then
    alias apt-get="apt-fast"
    alias aptins="apt-fast install --no-install-recommends -y"
fi

# ag #
if isServiceExist ag; then
    alias ag="ag -i --pager=less"
fi

# docker #
if isServiceExist docker; then
    # new kind of alias, better at history search
    alias dk="docker"
    alias dk_rm_dangling_image="docker images -qf dangling=true | xargs -r docker rmi"
    alias dk_rm_dangling_volume="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    alias dk_stop_all_ps="docker stop \$(docker ps -q)"
    alias dk_rm_all_ps="docker rm -fv \$(docker ps -aq)"
    alias dk_exec_it="docker exec -it"
fi

if isServiceExist docker-compose; then
    alias dc="docker-compose"
    alias dc_build="docker-compose build --force-rm"
    alias dc_up="docker-compose up -d --build"
fi

# fzf common #
if isServiceExist fzf; then
    alias ports='netstat -tulanp | fzf'
    alias psaux="ps aux | fzf"
else
    alias ports='netstat -tulanp'
    alias psaux="ps aux"
fi

# git
if isServiceExist git; then alias g="git"; fi

# xinput
declare builtinKeyboard="AT Translated Set 2 keyboard"
alias xinput_list_keyboard="xinput list | grep '${builtinKeyboard}'"
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias xinput_list_keyboard_id="xinput list | grep '${builtinKeyboard}' | awk '{print \$7}' | cut -c 4-5"
alias xinput_disable_keyboard="xinput float '$(xinput_list_keyboard_id)'"
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput_enable_keyboard="xinput reattach '$(xinput_list_keyboard_id)' 3"

# use xdg-open to open any file with default app
# should use & at the end to run the process in background otherwise we cannot continue using the cli
if isServiceExist xdg-open; then
    alias open="xdg-open"
fi
