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
alias mv="mv -v"
alias m="man"
alias mk="mkdir"
alias now='date +"%d-%m-%Y %T"'
alias nowdate='date +"%d-%m-%Y"'
alias nowtime='date +"%T"'
alias open="xdg-open"
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 4'
alias ram="sudo lshw -short -C memory"
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
alias wp="cd ~/vimwiki/personal"
alias wd="cd ~/vimwiki/development"

if _is_service_exist "apt-fast"; then
    alias apt-get="apt-fast"
    alias apti="apt-fast install --no-install-recommends -y"
    alias aptu="apt-fast update"
    alias aptr="sudo apt purge"
fi

if _is_service_exist "fzf"; then
    alias fs="_fzf_find_in_files" # search text in files
    alias fm="_fzf_man"
    alias ft="_fzf_tldr"
        # ex: fs abc - search all files contain 'abc'
        # ex: fs abc vim - search all '.vim' files contain 'abc'
    alias ports="netstat -tulanp | fzf"
    alias psaux="ps aux | fzf"
else
    alias ports="netstat -tulanp"
    alias psaux="ps aux"
fi

if _is_service_exist "safe-rm"; then
    alias rm="safe-rm" # replace rm with safe-rm
else
    alias rm='rm --preserve-root' # safety
fi
# }

# desk {
if _is_service_exist "desk"; then
    alias d="desk"
    alias de="desk edit"
    alias dg="_desk" # desk go to desk setup
fi
# }

# docker {
if _is_service_exist "docker"; then
    alias dk="docker"
    alias dkim="docker images"
    alias dkps="docker ps"
    alias dke="docker exec -it"
    alias dk_rm_dangling_image="docker images -qf dangling=true | xargs -r docker rmi"
    alias dk_rm_dangling_volume="docker volume ls -qf dangling=true | xargs -r docker volume rm"
    alias dk_stop_all_ps="docker stop \$(docker ps -q)"
    alias dk_rm_all_ps="docker rm -fv \$(docker ps -aq)"
fi

if _is_service_exist "docker-compose"; then
    alias dc="docker-compose"
    alias dcb="docker-compose build --force-rm"
    alias dcu="docker-compose up -d --build"
fi
if _is_service_exist "lazydocker"; then
    alias lzd="lazydocker"
fi
# }

if _is_service_exist ffmpeg; then
    alias ffmpeg_add_sub_to_video="_ffmpeg_add_sub_to_video"
fi

if _is_service_exist helm; then
    alias helm_template="_helm_template" # locally render helm template, does not apply any update
    alias helm_upgrade="helm upgrade --reuse-values"
        # safe guard, always reuse current values
        # https://medium.com/@kcatstack/understand-helm-upgrade-flags-reset-values-reuse-values-6e58ac8f127e
    alias helm_values="helm get values"
fi

# gcloud {
if _is_service_exist "gcloud"; then
    alias gcp="gcloud"
    alias gcp_cluster="_gcloud_cluster"
    alias gcp_cluster_nodepool="_gcloud_cluster_nodepool"
    alias gcp_compute="gcloud compute"
    alias gcp_compute_disk="_gcloud_disk"
    alias gcp_compute_instance="gcloud compute instances"
    alias gcp_compute_instance_list="_gcloud_compute"
    alias gcp_compute_instance_select="_gcloud_compute_display"
    alias gcp_log_event_hpa="_gcp_log_event_hpa"
    alias gcp_log_kevent="_gcp_log_kevent"
    alias gcp_sql="_gcloud_sql"
    alias gcp_service="_gcloud_service"
fi

if _is_service_exist "kubectl"; then
    alias k="kubectl"
    alias kss="k9s"
    alias kcx="kubectx" # switch kubernetes context
    alias kns="kubens" # switch namespace

    alias kca="kubectl describe -n kube-system configmap cluster-autoscaler-status" # cluster autoscaler status
    alias kd="_kube_deployment"
    alias ke="_kube_event"
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
    alias kpu="_kube_pod_usage"
    alias ks="_kube_service"

    alias k_resource="kubectl-resource_capacity --pods --util --sort cpu.request"
fi
# }

# git {
if _is_service_exist "git"; then
    alias g="git"
    alias mgst="mgst" # https://github.com/fboender/multi-git-status
        # Show uncommited, untracked and unpushed changes in multiple Git repositories

    alias gl_create_project_pr="gitlab create_project_pr"

    alias gl_projects="gitlab projects --field id --field visibility --field web_url --field web_url_to_repo --field default_branch --field creator_id --format table"
    alias gl_projects_urls="gitlab projects --field web_url --format fzf"
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

if _is_service_exist "pgcli"; then
    alias pgcli_dev="pgcli postgres://dev:dev@localhost:5432/dev" # default connect for postgres in localhost
fi

# search {
    alias s="_rg_file_pattern"
# }

# supervisor {
# if _is_service_exist supervisorctl; then
#     alias s="sudo supervisorctl"
#     alias sr="sudo supervisorctl reload"
#     alias ss="sudo supervisorctl status"
# fi
# }

# nvm {
# though we can use zsh-nvm plugin, it would slow down the terminal startup time
# therefore only load it when needed is better for performance
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'
# }

# tmux {
if _is_service_exist "tmux"; then
    alias tm="tmux"
    alias tmr="tmux source ~/.tmux.conf" # reload tmux session
    alias tmkill="tmux kill-session" # kill current tmux session
    alias tmkillall="tmux kill-server" # cleanly kill all sessions and running server
    # unbind all key (USE WITH CAUTION, use to remove cached bind-key)
    # note that all builtin bind key will be destroyed as well, should kill and restart tmux
    alias tmunbindallkeys="tmux unbind-key -a"
fi
if _is_service_exist "tmuxp"; then
    alias tmp="tmuxp"
    alias tmpl="tmuxp load"
    alias tmk="tmux kill-session -t"
fi
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
alias yt-dl-mp4="youtube-dl --format 'bestvideo[height=1080]+bestaudio[ext=m4a]/bestvideo[height=1080]+bestaudio/best' --merge-output-format mp4 -o '%(title)s.%(ext)s'"
alias yt-dl-mkv="_youtube_download_video_mkv"
alias yt-dl-sub="_youtube_download_sub"
alias yt-dl-sub-auto="youtube-dl --write-auto-sub --skip-download"
