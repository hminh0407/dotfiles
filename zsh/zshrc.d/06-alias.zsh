# Store all aliases

# Pattern for alias naming
#
# pattern: <app>_<operations>_... - use '_' to separate letter and word for complex operation (readalibity is more important than shortcut)
#
# pattern: <app><feature> - alias with no action is mean to show information
# example: <docker><process>
# example: dkps="docker ps -a" - list running docker container
#
# pattern: replace current command to add more feature
# example: ping='ping -c 4'

# common_alias {
alias chgrp='chgrp --preserve-root' # safety
alias chmod='chmod --preserve-root' # safety
alias chown='chown --preserve-root' # safety
alias cpu='lscpu'
alias gr="cat /etc/group"
alias netip="dig +short myip.opendns.com @resolver1.opendns.com"
alias mv="mv -v"
alias m="man"
alias mk="mkdir"
alias ls="ls --color=auto"
alias ll="ls -l"
alias lla="ls -la"
alias lrt="ls -lart"
alias now='date +"%d-%m-%Y %T"'
alias nowdate='date +"%d-%m-%Y"'
alias nowtime='date +"%T"'
alias timePrefix='date +"%Y%m%d%H%M%S"' # create a date time string that can be used as prefix for file's name
alias datePrefix='date +"%Y%m%d"' # create a date time string that can be used as prefix for file's name
alias open="xdg-open"
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 4'
alias ram="sudo lshw -short -C memory"
alias rm='rm --preserve-root' # safety
alias services='systemctl list-units --type=service'
alias t="touch"
alias tl="tldr -p linux"
alias wget="wget -c"
alias vii="vim -c ':PlugInstall!'"
alias viu="vim -c ':PlugUpdate!' "
alias vin="vim -u NONE"

alias rn="rename" # ex: rename 's/{searchString}/{replaceString}/' *.sh
alias rndryrun="rename -n" # rename -n 's/{searchString}/{replaceString}/' *.sh
alias untargz="tar -xvzf"
alias targz="tar -cvzf"

alias benchmark-shell="for i in \$(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done"

alias dot_chezmoi="cd ~/.local/share/chezmoi"
# alias dot="cd ~/dotfiles"
alias dot="chezmoi"
alias wp="cd ~/wiki/personal"
alias wd="cd ~/wiki/development"

alias apti="apt-fast install --no-install-recommends -y"

alias sysinfo="ps -o pid,user,%cpu,%mem,command ax | sort -b -k3 -r"

if [ -x "$(command -v chezmoi)" ]; then
    alias c="chezmoi"
    alias c_sourcepath="chezmoi source-path"
fi

if [ -x "$(command -v fzf)" ]; then
    alias fs="_fzf_find_in_files" # search text in files
    alias fm="_fzf_man"
    alias ft="_fzf_tldr"
        # ex: fs abc - search all files contain 'abc'
        # ex: fs abc vim - search all '.vim' files contain 'abc'
    alias fp="netstat -tulanp | fzf"
    alias psaux="ps aux | fzf"

    # if [ -x "$(command -v enable-fzf-tab)" ]; then
    enable-fzf-tab
    # fi
else
    alias ports="netstat -tulanp"
    alias psaux="ps aux"
fi

# }

alias disk_cleanup=_cleanup_disk_space

# check {{{

alias check_disk_size="du -h --max-depth=1"
    # require to pass a dir
alias check_file_system="df -h"

alias check_mem="free -mh"
alias check_cpu="mpstat"

alias check_req_redirect="_check_redirect"
alias check_req_status="curl --max-time 3 --location --silent --insecure --post301 --post302 --post303 --output /dev/null --write-out '%{http_code}'"
    # example: curl -L -s -o /dev/null -w '%{http_code}' google.com
    # get status of a site
    # --location: to follow redirect link
    # --max-time: to only wait for 3s if the site does not response
    # --insecure: allows curl to proceed and operate even for server connections otherwise considered insecure
    # --post301 --post302 --post303: not change the non-GET request method to GET after a 30x response

alias check_out_ip="curl icanhazip.com"
alias check_network_private_ip="ip route get 1.2.3.4 | awk '{print $7}'"

alias check_port="sudo netstat -lntup"

alias check_route="route -n"
    # this can follow with below command to delete a specific route
    # `sudo route del -net 0.0.0.0 gw 10.11.0.41 netmask 0.0.0.0 dev tun0`

# }}}

# dirdiff {{
alias dirdiff="_dirdiff"
# }}

# desk {

if [ -x "$(command -v desk)" ]; then
    alias d="desk"
    alias de="desk edit"
    alias dg="_desk" # desk go to desk setup
fi
# }

# docker {
if [ -x "$(command -v docker)" ]; then
    alias dfimage="sudo docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"
        # https://stackoverflow.com/questions/19104847/how-to-generate-a-dockerfile-from-an-image
    alias dk="docker"
    alias dkim="docker images"
    alias dkps="docker ps"
    alias dkpsa="docker ps -a"
    alias dke="docker exec -it"
    alias dk_rm_dangling_image="docker images -qf dangling=true | xargs -r docker rmi"
    alias dk_rm_dangling_volume="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    alias dk_stop_all_ps="docker stop \$(docker ps -q)"
    alias dk_rm_all_ps="docker rm -fv \$(docker ps -aq)"
    alias dk_rm_all_image="docker rmi $(docker images -aq)"
    alias dk_rabbitmq_erlang_cookie="docker run -d --name some-rabbit rabbitmq:3.8-alpine > /dev/null; sleep 5; docker exec -it some-rabbit cat /var/lib/rabbitmq/.erlang.cookie 2> /dev/null; echo; docker container rm some-rabbit -f > /dev/null"
        # generate erlang cookie used for rabbitmq provision
fi


if [ -x "$(command -v docker-compose)" ]; then
    alias dc="docker-compose"
    alias dcb="docker-compose build --force-rm"
    alias dcu="docker-compose up -d --build"
fi

# }

if [ -x "$(command -v ffmpeg)" ]; then
    alias ffmpeg_add_sub_to_video="_ffmpeg_add_sub_to_video"
    alias ffmpeg_add_sub_to_mp4_video="_ffmpeg_add_sub_to_mp4_video"
    alias ffmpeg_add_hard_ass_sub_to_mp4_video="_ffmpeg_add_hard_ass_sub_to_mp4_video"
    alias ffmpeg_cut_video="_ffmpeg_cut_video"
fi

if [ -x "$(command -v helm)" ]; then
    alias helm_template="_helm_template" # locally render helm template, does not apply any update
    alias helm_upgrade="helm upgrade --reuse-values"
        # safe guard, always reuse current values
        # https://medium.com/@kcatstack/understand-helm-upgrade-flags-reset-values-reuse-values-6e58ac8f127e
    alias helm_values="helm get values"
fi

# alias helm3="docker run -ti --rm -v $(pwd):/apps -v ~/.kube:/root/.kube -v ~/.helm3:/root/.helm alpine/helm:3.5.2"
alias helm2="/snap/bin/helm"

# gcloud {
if [ -x "$(command -v gcloud)" ]; then
    # alias gcp="gcloud"
    alias gcp_cluster="_gcloud_cluster"
    alias gcp_cluster_nodepool="_gcloud_cluster_nodepool"
    alias gcp_compute="gcloud compute"
    alias gcp_compute_disk="gcloud compute disks list"
    alias gcp_compute_disk_list_unused="_gcloud_compute_disk_find_unused"
    alias gcp_compute_disk_delete_unused="_gcloud_compute_disk_delete_unused"
    alias gcp_compute_instance="gcloud compute instances"
    alias gcp_compute_instance_list="_gcloud_compute"
    alias gcp_compute_instance_select="_gcloud_compute_display"
    alias gcp_compute_ssh="gcloud compute ssh --internal-ip"
    alias gcp_deployment="gcloud deployment-manager deployments list"
    alias gcp_ip="gcloud compute addresses list"
    alias gcp_ip_reserved_external="gcloud gcp compute addresses list --filter='status=RESERVED AND addressType=EXTERNAL'"
    # alias gcp_log_event_hpa="_gcp_log_event_hpa"
    # alias gcp_log_kevent="_gcp_log_kevent"
    alias gcp_scp="gcp compute scp --internal-ip"
    # alias gcp_service_account_policy="_gcp_service_account_iam_policy"
    alias gcp_sql="gcloud sql instances list"
    alias gcp_service="gcloud services list --format='table(config.name,config.title,config.documentation.summary)'"
    alias gcp_ssh="gcloud compute ssh --internal-ip"
    alias gcp_project="gcloud config get-value project -q"
fi

if [ -x "$(command -v kubectl)" ]; then
    alias k="kubectl"
    alias kg="kubectl get"
    alias ke="kubectl edit"
    alias kd="kubectl describe"

    alias kss="k9s"
    alias kcx="kubectx" # switch kubernetes context
    alias kns="kubens" # switch namespace

    alias kgp="kubectl get pod"
    alias kgpi="kubectl get pod --field-selector='status.phase!=Running,status.phase!=Succeeded'"
        # get inactive pods
    alias kgp_crash="kubectl get pod --field-selector='status.phase==Failed' --all-namespaces"
    alias kgp_crash_delete="kubectl delete pod --field-selector='status.phase==Failed' --all-namespaces"

    alias kgd="kubectl get deployment"
    alias ked="kubectl edit deployment"

    alias kgn="kubectl get node"

    alias kgs="kubectl get service"
    alias kes="kubectl edit service"

    alias kgss="kubectl get statefulset"
    alias kess="kubectl edit statefulset"

    alias kgi="kubectl get ingress"
    alias kei="kubectl edit ingress"

    alias kl="kubectl logs -f --tail 100"

    alias kge="kubectl get event"

    alias kgh="kubectl get hpa"
    alias keh="kubectl edit hpa"

    alias k_api_resources="kubectl api-resources"
    alias k_image="_kube_image"

    alias k_config_current_ctx="_kube_config_current_context"
    alias k_config_current_ns="_kube_config_current_namespace"

    alias k_check_apiversion="k get all -o custom-columns='NAME:metadata.name,KIND:kind,VERSION:apiVersion' --all-namespaces"

    alias k_resource="kubectl-resource_capacity --util --sort cpu.request"
    alias k_resource_with_pod="kubectl-resource_capacity --pods --util --sort cpu.request"

    alias k_event="kubectl get events --sort-by=.metadata.creationTimestamp"

    alias k_netshoot="kubectl run tmp-netshoot --rm -i --tty --image nicolaka/netshoot -- /bin/bash"
        # https://github.com/nicolaka/netshoot
        # run a tmp pod to debug kubernetes network
    alias k_pods="get pods"

    alias k_cost="kubectl cost"
    alias k_cost_namespace="kubectl cost namespace --show-all-resources"
    alias k_cost_label="kubectl cost label -l" # provide label

    # _kube_alias
fi
# }

# git {
if [ -x "$(command -v git)" ]; then
    alias g="git"
    alias mgst="mgst" # https://github.com/fboender/multi-git-status
        # Show uncommited, untracked and unpushed changes in multiple Git repositories

    alias gl_create_project_pr="gitlab create_project_pr"
    alias gl_create_project_tag="gitlab create_project_tag"

    alias gl_projects="gitlab projects --field id --field visibility --field web_url --field web_url_to_repo --field default_branch --field creator_id --format table"
    alias gl_projects_urls="gitlab projects --field web_url --format fzf"
    alias gl_projects_ssh="gitlab projects --field ssh_url_to_repo --format table"
    alias gl_project="gitlab project"
    alias gl_project_tags="gitlab project_tags --field name --field commit.title --field commit.created_at --field commit.author_email --format table"
    alias gl_project_url="gitlab project | fx .web_url"
    alias gl_project_branch="gitlab project | fx .default_branch"

    alias gl_prs="gitlab prs --field title --field source_branch --field target_branch --field web_url --field author.username --field assignee.username --format table"
    alias gl_prs_usr="gl_prs --param author_id=\$(gitlab user | fx '.id') --format table"

    alias gl_usrs="gitlab users"
    alias gl_usr="gitlab user"
fi
# }

if [ -x "$(command -v mssql-cli)" ]; then
    alias mssql="mssql-cli --mssqlclirc ~/.mssqlclirc"
fi

# nvm
# if [ -x "$(command -v tmux)" ]; then
#     alias nvmload="nvm use --lts"
# fi

# request
if [ -x "$(command -v curl)" ]; then
    alias rq="curl -L"
    alias rq_domain_ip_mapping="_rq_domain_ip_mapping"
    alias rqo="curl -I " # request option
fi


# search {
    alias s="_rg_file_pattern"
    alias s_f="_rg_file_pattern -l"
        # output only filename
    alias sf="_rg_file"
# }

if [ -x "$(command -v shnsplit)" ]; then
    alias splitFlac="_splitFlac"
fi

# terraform {
if [ -x "$(command -v terraform)" ]; then
    alias tf="terraform"
fi
# }

# tmux {
if [ -x "$(command -v tmux)" ]; then
    alias tm="tmux"
    alias tmr="tmux source ~/.tmux.conf" # reload tmux session
    alias tmkill="tmux kill-session" # kill current tmux session
    alias tmkillall="tmux kill-server" # cleanly kill all sessions and running server
    # unbind all key (USE WITH CAUTION, use to remove cached bind-key)
    # note that all builtin bind key will be destroyed as well, should kill and restart tmux
    alias tmunbindallkeys="tmux unbind-key -a"
fi
if [ -x "$(command -v tmuxp)" ]; then
    alias tmp="tmuxp"
    alias tmpl="tmuxp load"
    alias tmk="tmux kill-session -t"
fi
# }

if [ -x "$(command -v wavemon)" ]; then
    alias wifi_info="sudo wavemon"
fi

# troubleshoot {
    # https://askubuntu.com/questions/768463/laptop-headphone-jack-produces-no-sound
    alias fix_sound="alsactl restore"
# }

# xinput {
declare builtinKeyboard="AT Translated Set 2 keyboard"
# Normal use of awk with alias will not run as expected, check for more detail on https://stackoverflow.com/a/24247870
alias _xinput_list_keyboard_id="xinput list | grep '${builtinKeyboard}' | awk '{print \$7}' | cut -c 4-5"
alias xinput_disable_keyboard="xinput float \$(_xinput_list_keyboard_id)"
# xinput reattach <id> <master> (master default to be 3)
# Check for more detail: https://askubuntu.com/questions/160945/is-there-a-way-to-disable-a-laptops-internal-keyboard
alias xinput_enable_keyboard="xinput reattach \$(_xinput_list_keyboard_id) 3"
# }

# https://unix.stackexchange.com/a/454072/388893
# download the best 1080p video quality
# download the best mp4 compatible audio quality
# convert output format to mp4
# alias yt_dl_mp4="youtube-dl --format 'bestvideo[height=1080]+bestaudio[ext=m4a]/bestvideo[height=1080]+bestaudio/best' --merge-output-format mp4 -o '%(title)s.%(ext)s'"
# alias yt_dl_mp3="youtube-dl --format 'bestaudio/best' --extract-audio --audio-format mp3 -o '%(title)s.%(ext)s'"
# alias yt_dl_mkv="_youtube_download_video_mkv"
# alias yt_dl_sub="_youtube_download_sub"
# alias yt_dl_sub_auto="youtube-dl --write-auto-sub --skip-download"
# alias vtt_to_srt="_vtt_to_srt"
