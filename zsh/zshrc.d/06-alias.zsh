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
alias evi="vi -u NONE"
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

alias dot="cd ~/dotfiles"
alias wp="cd ~/wiki/personal"
alias wd="cd ~/wiki/development"

alias apti="apt-fast install --no-install-recommends -y"

alias sysinfo="ps -o pid,user,%cpu,%mem,command ax | sort -b -k3 -r"

if [ -x "$(command -v fzf)" ]; then
    alias fs="_fzf_find_in_files" # search text in files
    alias fm="_fzf_man"
    alias ft="_fzf_tldr"
        # ex: fs abc - search all files contain 'abc'
        # ex: fs abc vim - search all '.vim' files contain 'abc'
    alias ports="netstat -tulanp | fzf"
    alias psaux="ps aux | fzf"

    # if [ -x "$(command -v enable-fzf-tab)" ]; then
    enable-fzf-tab
    # fi
else
    alias ports="netstat -tulanp"
    alias psaux="ps aux"
fi

alias check_udp_port="nc -z -v -u"
    # nc -z -v -u [hostname/IP address] [port number]

# }

alias disk_cleanup=_cleanup_disk_space

# curl {{{
# some useful curl alias
alias curl_check_redirect="_check_redirect"
alias curl_status="curl --max-time 3 --location --silent --insecure --post301 --post302 --post303 --output /dev/null --write-out '%{http_code}'"
    # example: curl -L -s -o /dev/null -w '%{http_code}' google.com
    # get status of a site
    # --location: to follow redirect link
    # --max-time: to only wait for 3s if the site does not response
    # --insecure: allows curl to proceed and operate even for server connections otherwise considered insecure
    # --post301 --post302 --post303: not change the non-GET request method to GET after a 30x response
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
    alias dk="docker"
    alias dkim="docker images"
    alias dkps="docker ps"
    alias dke="docker exec -it"
    alias dk_rm_dangling_image="docker images -qf dangling=true | xargs -r docker rmi"
    alias dk_rm_dangling_volume="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    alias dk_stop_all_ps="docker stop \$(docker ps -q)"
    alias dk_rm_all_ps="docker rm -fv \$(docker ps -aq)"
fi


if [ -x "$(command -v docker-compose)" ]; then
    alias dc="docker-compose"
    alias dcb="docker-compose build --force-rm"
    alias dcu="docker-compose up -d --build"
fi

if [ -x "$(command -v lazydocker)" ]; then
    alias lzd="lazydocker"
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

# gcloud {
if [ -x "$(command -v gcloud)" ]; then
    alias gcp="gcloud"
    alias gcp_cluster="_gcloud_cluster"
    alias gcp_cluster_nodepool="_gcloud_cluster_nodepool"
    alias gcp_compute="gcloud compute"
    alias gcp_compute_disk="_gcloud_disk"
    alias gcp_compute_instance="gcloud compute instances"
    alias gcp_compute_instance_list="_gcloud_compute"
    alias gcp_compute_instance_select="_gcloud_compute_display"
    alias gcp_compute_ssh="gcloud compute ssh --internal-ip"
    alias gcp_ip="gcloud compute addresses list"
    alias gcp_ip_reserved_external="gcloud gcp compute addresses list --filter='status=RESERVED AND addressType=EXTERNAL'"
    alias gcp_log_event_hpa="_gcp_log_event_hpa"
    alias gcp_log_kevent="_gcp_log_kevent"
    alias gcp_scp="gcp compute scp --internal-ip"
    alias gcp_service_account_policy="_gcp_service_account_iam_policy"
    alias gcp_sql="_gcloud_sql"
    alias gcp_service="_gcloud_service"
    alias gcp_ssh="gcloud compute ssh --internal-ip"
fi

if [ -x "$(command -v kubectl)" ]; then
    alias k="kubectl"
    alias kss="k9s"
    alias kcx="kubectx" # switch kubernetes context
    alias kns="kubens" # switch namespace

    alias kca="kubectl describe -n kube-system configmap cluster-autoscaler-status" # cluster autoscaler status
    alias kd="_kube_deployment"
    # alias ke="_kube_event"
    alias ke="kubectl get events --sort-by=.metadata.creationTimestamp"
    alias ke_hpa="_kube_event_hpa"
    alias khpa="_kube_hpa"
    alias khpa_multi_replica="_kube_hpa_multi_replica"
    alias khpa_validate="_kube_hpa_validate"
    alias ki="_kube_ingress"
    alias kn="_kube_node"
    alias knu="_kube_node_usage"
    alias knpd="_kube_nodepool_drain"
    alias kp="_kube_pod"
    alias kpa="_kube_pod_all"
    alias kpi="_kube_pod_inactive"
    alias kp_failed="kubectl get pod --field-selector='status.phase==Failed' --all-namespaces"
    alias kpu="_kube_pod_usage"
    alias ks="_kube_service"

    alias k_config_current_ctx="_kube_config_current_context"
    alias k_config_current_ns="_kube_config_current_namespace"

    alias k_check_apiversion="k get all -o custom-columns='NAME:metadata.name,KIND:kind,VERSION:apiVersion' --all-namespaces"

    alias k_resource="kubectl-resource_capacity --pods --util --sort cpu.request"

    alias k_event="kubectl get events --sort-by=.metadata.creationTimestamp"
fi
# }

# git {
if [ -x "$(command -v git)" ]; then
    alias g="git"
    alias mgst="mgst" # https://github.com/fboender/multi-git-status
        # Show uncommited, untracked and unpushed changes in multiple Git repositories

    alias gl_create_project_pr="gitlab create_project_pr"

    alias gl_projects="gitlab projects --field id --field visibility --field web_url --field web_url_to_repo --field default_branch --field creator_id --format table"
    alias gl_projects_urls="gitlab projects --field web_url --format fzf"
    alias gl_projects_ssh="gitlab projects --field ssh_url_to_repo --format table"
    alias gl_project="gitlab project"
    alias gl_project_tags="gitlab project_tags --field name --field commit.title --field commit.created_at --field commit.author_email --format table"
    alias gl_project_url="gitlab project | fx .web_url"
    alias gl_project_branch="gitlab project | fx .default_branch"

    alias gl_prs="gitlab prs --field title --field source_branch --field target_branch --field web_url --field author.username --field assignee.username --format table"
    alias gl_prs_usr="gl_prs --param author_id=\$(gitlab user | fx '.id') --format table"

    # alias gl_pr_create="_gitlab_pr_create"
    # alias gl_pr_update="_gitlab_pr_update"

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
alias yt_dl_mp4="youtube-dl --format 'bestvideo[height=1080]+bestaudio[ext=m4a]/bestvideo[height=1080]+bestaudio/best' --merge-output-format mp4 -o '%(title)s.%(ext)s'"
alias yt_dl_mp3="youtube-dl --format 'bestaudio/best' --extract-audio --audio-format mp3 -o '%(title)s.%(ext)s'"
alias yt_dl_mkv="_youtube_download_video_mkv"
alias yt_dl_sub="_youtube_download_sub"
alias yt_dl_sub_auto="youtube-dl --write-auto-sub --skip-download"
alias vtt_to_srt="_vtt_to_srt"
