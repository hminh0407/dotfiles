# === Base ===
# contain base functions for other scripts. Need to be in the first order

_append_to_file_if_not_exist() {
    [ -z "$1" ] && { echo  "missed param 'line'"; exit 1; }
    [ -z "$2" ] && { echo  "missed param 'file'"; exit 1; }
    local line="$1"
    local file="$2"
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

_check_redirect() {
    echo
    for domain in $@; do
    echo --------------------
    echo $domain
    echo --------------------
    curl -sILk $domain | egrep 'HTTP|Loc' | sed 's/Loc/ -> Loc/g'
    echo
    done
}

_cleanup_disk_space() {
    # steps are referred from this article https://itsfoss.com/free-up-space-ubuntu-linux/
    sudo apt-get autoremove

    # clean up apt cache
    sudo apt-get autoclean

    # Clear systemd journal logs
    journalctl --disk-usage && sudo journalctl --vacuum-time=3d

    # remove thumbnails cache
    sudo rm -rf ~/.cache/thumbnails/*
}

_join_by() {
    # join elements of array by a delimiter
    local delimiter="$1" # Save first argument in a variable
    shift            	 # Shift all arguments to the left (original $1 gets lost)
    local items=("$@")   # Rebuild the array with rest of arguments

    # local IFS=$delimiter; shift; echo "$*";
    local IFS=$delimiter; echo "${items[*]}";
    # example usages
    # join_by , a "b c" d     # a,b c,d
    # join_by / var local tmp # var/local/tmp
    # join_by , "${FOO[@]}"   # a,b,c

    # Reference (from `man bash`)
    # If the word is double-quoted, ${name[*]} expands to a single word
    #     with the value of each array member separated by the first character of the IFS special variable,
    # and ${name[@]} expands each element of name to a separate word.

    # Example
    # array=("1" "2" "3")
    # printf "'%s'" "${array[*]}"
    # '1 2 3'
    # printf "'%s'" "${array[@]}"
    # '1''2''3'
}

_rq_domain_ip_mapping() {
    # use in situation when we need to send request to a proxy with ip address with DNS resolve
    local domain="$1"
    local ip="$2"

    curl -L -v $domain --resolve $domain:80:$ip --resolve $domain:443:$ip
    # which will force cURL to use  "127.0.0.1" as the IP address for requests to "www.example.com " over ports 80 (HTTP and 443 (HTTPS).
    # This can be useful for sites that automatically redirect HTTP requests to HTTPS requests as a security measure.
}

_urlencode() {
    # https://stackoverflow.com/a/10660730/1530178
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos=""
    local c=""
    local o=""

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
           [-_.~a-zA-Z0-9] ) o="${c}" ;;
           * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"    # You can either set a return variable (FASTER)
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

# ===============================================
#
_dirdiff() {
    # Shell-escape each path:
    DIR1=$(printf '%q' "$1"); shift
    DIR2=$(printf '%q' "$1"); shift
    vim $@ -c "DirDiff $DIR1 $DIR2"
}

if [ -x "$(command -v desk)" ]; then
    _desk() { # list all pre-defined desk and cd to selected desk if possible
        if [ -x "$(command -v fzf)" ]; then
            local folder=$(desk ls | fzf | awk '{print $1}')
            if [ -n "${folder:+1}" ]; then
                desk go $folder
            fi
        else
            desk ls && return
        fi
    }
fi

if [ -x "$(command -v fzf)" ]; then
    _fzf_alias() { # show all alias
        alias | fzf | awk '{split($0,a,"="); print a[1]}'
    }

    _fzf_docker_container() { # show list and can select multiple
        # echo $(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Ports}}" | fzf --multi | awk '{print $1}')
        local ps=$(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Ports}}" | fzf --multi | awk '{print $1}')
        if [ -n "${ps:+1}" ]; then echo $ps; fi
    }

    _fzf_docker_images() { # show list and can select multiple
        local image=$(docker images | fzf --multi | awk '{print $1":"$2}')
        if [ -n "${image:+1}" ]; then echo $image; fi
    }

    _fzf_git_alias() { # show list and can select single
        git config -l | grep alias | cut -c 7- | fzf | awk '{split($0,a,"="); print a[1]}'
    }

    _fzf_git_branch() { # show list and can select multiple
        if [ "$(git is-in-git-repo)" ]; then
            # NOTE: preview mode seem to have problem with latest linux kernel https://github.com/junegunn/fzf/issues/1486.
            # Until it is fixed use normal mode instead
            #
            # Pass the list of the branches to fzf
            # - "{}" in preview option is the placeholder for the highlighted entry
            # - Preview window can display ANSI colors, so we enable --color=always
            # - We can terminate `git show` once we have $LINES lines
            git branch | awk '{$1=$1};1' |
                fzf --multi --preview-window right:70% \
                --preview 'git show --color=always {} | head -'$LINES
                    # git branch --all | awk '{$1=$1};1' | fzf --multi # in case above script don't work
        fi
    }

    _fzf_git_tag() { # show list and can select multiple
        if [ "$(git is-in-git-repo)" ]; then
            # NOTE: preview mode seem to have problem with latest linux kernel https://github.com/junegunn/fzf/issues/1486.
            # Until it is fixed use normal mode instead
            #
            # Pass the list of the tags to fzf
            # - "{}" in preview option is the placeholder for the highlighted entry
            # - Preview window can display ANSI colors, so we enable --color=always
            # - We can terminate `git show` once we have $LINES lines
            git tag --sort -version:refname |
                fzf --multi --preview-window right:70% \
                --preview 'git show --color=always {} | head -'$LINES
                    # git tag --sort -version:refname | fzf --multi # in case above don't work
        fi
    }

    _fzf_find_in_files() { # display files that contain search string with preview window
        if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
        local filetype="$2"
        if [ -n $filetype ]; then
            rg --files-with-matches --no-messages "$1" -g "$2" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
        else
            rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
        fi
    }

    _fzf_man() { # find man page and display selected item
        man -k . | fzf | awk '{print $1}' | xargs -r man
    }

    _fzf_tldr() {
        tldr -l | sed 1d | xargs -n 1 | fzf --ansi --preview 'tldr {} | head -100' | xargs -r tldr
    }
fi

if [ -x "$(command -v helm)" ]; then
    _helm_template() {
        [ -z "$1" ] && { echo  "missing chart name"; exit 1; }
        [ -z "$2" ] && { echo  "missing template file"; exit 1; }
        [ -z "$3" ] && { echo  "missing value file"; exit 1; }
        [ -z "$4" ] && { echo  "missing release name"; exit 1; }

        local chart="$1"
        local template="$2"
        local value="$3"
        local release="$4"

        helm template $chart -x $template -f $value --name $release
    }
fi

if [ -x "$(command -v gcloud)" ]; then

    _gcloud_cluster() { # list of kubernetes cluster
        local mode="$1"

        case "$mode" in
            name*) # only output name list
                gcloud container clusters list --format="table[no-heading](name)" --filter="location='asia-southeast1-a'"
                ;;
            *)
                gcloud container clusters list
        esac
    }

    _gcloud_cluster_nodepool() { # list all nodepool of all clusters
        local clusters=( $(_gcloud_cluster "name") )

        local nodepools=$(
            # echo "${clusters[1]}"
            gcloud container node-pools list --cluster="${clusters[1]}" | head -n 1 | awk '{print "CLUSTER", $0}';
                # get the header row
                # add header 'CLUSTER' at the beginning

            for c in $clusters; do
                gcloud container node-pools list --cluster="$c" --format="table[no-heading](name,config.machineType,config.diskSizeGb,version)" \
                    | awk '{print "'$c'", $0}'
                    # get list of nodepools
                    # add column cluster at the beginning
            done
        )

        echo $nodepools | column -t
    }

    _gcloud_sql() { # list of gcloud compute instances and describe selected instance if possible
        local fields=(
            'name'
            'databaseVersion'
            'gceZone'
            'settings.tier'
            'ipAddresses[0].ipAddress:label=PRIMARY_IP'
            'ipAddresses[1].ipAddress:label=NAT_IP'
            'ipAddresses[2].ipAddress:label=INTERNAL_IP'
            'settings.userLabels.list()'
            'state'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        gcloud sql instances list --format="$format_str"
    }

    _gcloud_compute_disk() { # list of gcloud compute instances and describe selected instance if possible
        local fields=(
            'name'
            'sizeGb'
            'type.basename()'
            'status'
            'labels.list()'
            'users.basename().list()'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        gcloud compute disks list --format="$format_str"
    }

    _gcloud_compute() {
        local fields=(
            'name'
            'zone.basename()'
            'machineType.basename()'
            'scheduling.preemptible.yesno(yes=true, no='')'
            'networkInterfaces[0].networkIP:label=INTERNAL_IP'
            'networkInterfaces[0].accessConfigs[0].natIP:label=EXTERNAL_IP'
            'status'
            'labels.list()'
            'disks[0].licenses.list()'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        local filter="$1"

        if [ -z $filter ]; then
            gcloud compute instances list --format="$format_str"
        else
            gcloud compute instances list --format="$format_str" --filter="$filter"
        fi
    }

    _gcloud_compute_snapshot() {
        local fields=(
            'name'
            'diskSizeGb'
            'sourceDisk.basename()'
            'status'
            'labels.list()'
            'creationTimestamp'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        local filter="$1"

        if [ -z $filter ]; then
            gcloud compute snapshots list --format="$format_str"
        else
            gcloud compute snapshots list --format="$format_str" --filter="$filter"
        fi
    }

    _gcloud_compute_disk() { # list of gcloud compute instances and describe selected instance if possible
        local fields=(
            'name'
            'sizeGb'
            'type.basename()'
            'status'
            'labels.list()'
            'users.basename().list()'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        gcloud compute disks list --format="$format_str"
    }

    _gcloud_compute_disk_find_unused() {
        gcloud compute disks list --format json \
            | fx '.filter(item => !item.users ).map( item => { return { id: item.id, name: item.name, last_attach: item.lastAttachTimestamp, last_dettach: item.lastDetachTimestamp, users: item.users } })' \
            | json2csv --quote '' \
            | csvformat -D ' '
    }

    _gcloud_compute_disk_delete_unused() {
        _gcloud_compute_disk_find_unused \
            | tail -n +2 \
            | awk '{print $2}' \
            | xargs -r gcloud compute disks delete
    }

    _gcloud_compute_display() {
        if [ -x "$(command -v fzf)" ]; then
            _gcloud_compute \
                | fzf                                            \
                | awk '{print $1}'                               \
                | xargs -r gcloud compute instances describe
        else
            gcloud compute instances list && return
        fi
    }

    _gcloud_compute_instance_filter_name() {
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local name="$1"

        gcloud compute instances list --uri --filter="name~'.*$name.*'"
    }

    _gcloud_compute_name_filter_no_label() { # return name list of all instances that do not have a specific label
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local label="$1"

        gcloud compute instances list --filter="-labels.${label}:*" --format="value(name)"
    }

    _gcloud_compute_disk_filter_no_label() { # return name list of all instances that do not have a specific label
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local label="$1"

        gcloud compute disks list --filter="-labels.${label}:*" --format="value(name)"
    }

    _gcloud_compute_name_filter_with_label() { # return list of all instances that have a specific label
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local label="$1"

        gcloud compute instances list --filter="labels.${label}:*" --format="value(name)"
    }

    _gcloud_compute_add_label() { # a label to an instance
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }
        [ -z "$2" ] && { echo  "missing argument"; exit 1; }
        [ -z "$3" ] && { echo  "missing argument"; exit 1; }

        local pattern="$1"
        local label_key="$2"
        local label_value="$3"

        for instance in $( gcloud compute instances list --uri --filter="name~'.*$pattern.*'" ); do
            gcloud compute instances add-labels --labels="$label_key=$label_value" $instance
        done
    }

    _gcloud_compute_disk_add_label() { # a label to an instance
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }
        [ -z "$2" ] && { echo  "missing argument"; exit 1; }
        [ -z "$3" ] && { echo  "missing argument"; exit 1; }

        local pattern="$1"
        local label_key="$2"
        local label_value="$3"

        for instance in $( gcloud compute disks list --uri --filter="name~'.*$pattern.*'" ); do
            gcloud compute disks add-labels --labels="$label_key=$label_value" $instance
        done
    }

    _gcloud_compute_snapshot_add_label() { # a label to an instance
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }
        [ -z "$2" ] && { echo  "missing argument"; exit 1; }
        [ -z "$3" ] && { echo  "missing argument"; exit 1; }

        local pattern="$1"
        local label_key="$2"
        local label_value="$3"

        for instance in $( gcloud compute snapshots list --uri --filter="name~'.*$pattern.*'" ); do
            gcloud compute snapshots add-labels --labels="$label_key=$label_value" $instance
        done
    }

    _gcloud_compute_snapshot_remove_label() { # a label to an instance
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }
        [ -z "$2" ] && { echo  "missing argument"; exit 1; }

        local pattern="$1"
        local labels="$2"

        for instance in $( gcloud compute snapshots list --uri --filter="name~'.*$pattern.*'" ); do
            gcloud compute snapshots remove-labels --labels="$labels" $instance
        done
    }

    _gcloud_compute_remove_label() { # remove a label from an instance
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }
        [ -z "$2" ] && { echo  "missing argument"; exit 1; }

        local instance="$1"
        local label_key="$2"

        gcloud compute instances add-labels "$instance" --labels="$label_key"
    }

    _gloud_compute_add_label_instance_name() { # add label instance-name={instance-name} for all instances that do not have this label
        local specific_instance="$1"

        local label_key="instance-name"
        local instances=( $(_gcloud_compute_name_filter_no_label $label_key) ) # list of instance name that do not have this label

        for instance in ${instances[@]}; do
            if [ -z $specific_instance ]; then
                _gcloud_compute_add_label "$instance" $label_key "$instance"
            elif [ $specific_instance = $instance ]; then
                _gcloud_compute_add_label "$instance" $label_key "$instance"
            fi
        done
    }

fi

if [ -x "$(command -v kubectl)" ]; then

    _kube_config_current_context() {
        # example:
            # context with name 'project-name-218206_asia-southeast1-a_cluster-name'
            # will be printed 'cluster-name'
        local delimiter="_"

        kubectl config current-context | awk '{n=split($1,A,"'$delimiter'"); print A[n]}'
    }

    _kube_config_current_namespace() {
        kubectl config view --output 'jsonpath={..namespace}'
    }

    _kube_context() {
        local mode="$1"

        case "$mode" in
            name*) # only output name list
                kubectl config get-contexts | awk '{print $2}' | tail -n +2
                ;;
            *)
                kubectl config get-contexts
        esac
    }

    _kube_deployment_name() {
        kubectl get deployment -o custom-columns="NAME:metadata.name" --no-headers
    }

    _kube_event_hpa() {
        # display hpa events in the last 1 hour
        local filter=(
            "involvedObject.kind=HorizontalPodAutoscaler"
        )
        local filterStr=$(_join_by ',' "${filter[@]}")

        local resultField=(
            'involvedObject.name:.involvedObject.name'
            'involvedObject.kind:.involvedObject.kind'
            # 'metadata.name:.metadata.name'
            'type:.type'
            'reason:.reason'
            'message:.message'
            'lastTimestamp:.lastTimestamp'
        )
        local resultFieldStr=$(_join_by ',' "${resultField[@]}")

        kubectl get events \
            -o custom-columns="$resultFieldStr" \
            --field-selector="$filterStr" \
            --sort-by=.lastTimestamp # asc order, latest event in the bottom
    }

    _kube_hpa_multi_replica() {
        # display hpa that has more than 1 replica
        kubectl get hpa -owide | awk '{ if($7 > 1) {print} }'
    }

    _kube_hpa_name() {
        kubectl get hpa -o custom-columns="NAME:metadata.name" --no-headers
    }

    _kube_hpa_validate() { # validate all hpa in current namespace
        local deployments=( $(_kube_deployment_name)) # list of deployment name

        local fields=(
            "NAME:metadata.name"
            "REF-KIND:spec.scaleTargetRef.kind"
            "REF-NAME:spec.scaleTargetRef.name"
        )
        local fieldStr=$( _join_by ',' "${fields[@]}" )

        # it's tricky to implement array of objects in bash, therefore use 3 arrays to handle
        local hpaNameList=( $(kubectl get hpa -o custom-columns="NAME:metadata.name" --no-headers --sort-by=.metadata.uid) )
        local hpaRefKindList=( $(kubectl get hpa -o custom-columns="REF-KIND:spec.scaleTargetRef.kind" --no-headers --sort-by=.metadata.uid) )
        local hpaRefNameList=( $(kubectl get hpa -o custom-columns="REF-NAME:spec.scaleTargetRef.name" --no-headers --sort-by=.metadata.uid) )

        local i=1
        for hpaName in "${hpaNameList[@]}"; do
            local hpaRefKind="${hpaRefKindList[$i]}"
            local hpaRefName="${hpaRefNameList[$i]}"
            local inDeployments=$(printf '%s\n' ${deployments[@]} | grep -P "^${hpaRefNameList[$i]}$" | wc -w)
                # inDeployments > 0 means item is exist in list

            # echo "$i - $hpaName - ${hpaNameList[$i]}" # for debug purpose
            if [ "Deployment" = "$hpaRefKind" ] && [ "$inDeployments" -eq 0 ]; then
                # check if hpa reference an existed deployment

                # echo "$i - $hpaName - $hpaRefKind - $hpaRefName - $inDeployments" # for debug purpose
                echo "hpa '$hpaName' reference a $hpaRefKind '$hpaRefName' which does not exist"
            fi

            let "i+=1"
        done
    }

    _kube_image() { # list all image used in cluster
        local image_pattern="$1"

        if [[ -n $image_pattern ]]; then
            kubectl get deployment --all-namespaces -o jsonpath="{..metadata.name}" | tr -s '[[:space:]]' '\n' | sort -u | grep "$image_pattern"
        else
            kubectl get deployment --all-namespaces -o jsonpath="{..metadata.name}" | tr -s '[[:space:]]' '\n' | sort -u
        fi
    }

    _kube_node_reschedule() {
        # safely reschedule all pods from one node to another
        local node_name="$1"

        # check for pod that can be safely delete
        # pods in testing or staging environment and downtime is acceptable
        local pattern="$2"
        kubectl get pod -owide | grep "$node_name" | awk '/'$pattern'/{print \$1}'

        # check for pod that need special treatment
        # pods in production environment and downtime is not acceptable

    }

    _kube_node_usage() {
            local mode="default"
            local current_context="$(kubectl config current-context)"
            local contexts=( $(_kube_context 'name') )

            local node=$(
                kubectl top node | head -n 1 |  awk '{print "CONTEXT", $0}';
                    # get the header row
                    # add header 'CONTEXT' at the beginning

                for c in ${contexts[@]}; do
                    kubectx $c >/dev/null && kubectl top node --no-headers | awk '{print "'$c'", $0}'
                        # change context
                        # get list of node usage
                        # add column context at the beginning
                done
            )
            kubectx $current_context >/dev/null # change back to current context

            echo $node | column -t
    }

    _kube_nodepool_drain() { # drain all the node inside a nodepool
        # run _gcloud_cluster_nodepool to find nodepool name
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local oldpool="$1"
        local oldnodes=( $(kubectl get no --selector="cloud.google.com/gke-nodepool=$oldpool" -o json | jq '.items[].metadata.name' -r) )

        kubectl cordon --selector="cloud.google.com/gke-nodepool=$oldpool"
            # Marking a node as unschedulable prevents new pods from being scheduled to that node, but does not affect any existing pods on the node

        for n in $oldnodes; do
            echo "draining $n"

            kubectl drain --delete-local-data --ignore-daemonsets $n
                # safely evict all pods from the node
            # read -n 1 -s -r -p "Press any key to continue" # bash version
                # confirm before each drain
                # -n defines the required character count to stop reading
                # -s hides the user's input
                # -r causes the string to be interpreted "raw" (without considering backslash escapes)
            read -k 1 "?Press any key to continue" # zsh version
                # anything after ? is used as prompt string
                # -k defines the required character count to stop reading

            echo "\n----------------------------"
        done;
    }

    _kube_find_unused_pvc_more_detail() {
        kubectl describe pvc --all-namespaces | grep -E "^Name:.*$|^Namespace:.*$|^Used By:.*$" | grep -B 2 "<none>"
    }

    _kube_find_unused_pvc() {
        _kube_find_unused_pvc_more_detail \
            | grep -E "^Name:.*$|^Namespace:.*$" \
            | cut -f2 -d: \
            | paste -d " " - - \
    }

    _kube_delete_unused_pvc() {
        # find all pvc that are not mounted to any pod
        # this taken from stackoverflow answer https://stackoverflow.com/a/59758937
        # It looks like the -o=go-template=... doesn't have a variable for Mounted By: as shown in kubectl describe pvc. Therefore this kind of hack is needed
        _kube_find_unused_pvc \
            | xargs -n2 bash -c 'kubectl -n ${1} delete pvc ${0}'
            # cut removes Name: and Namespace: since they just get in the way
            # paste puts the Name of the PVC and it's Namespace on the same line
            # xargs -n bash makes it so the PVC name is ${0} and the namespace is ${1}
    }

fi

_redis_copy_all(){
    # copy all redis keys from one server to another server

    [ -z "$1" ] && { echo  "missing source uri argument"; exit 1; }
    [ -z "$2" ] && { echo  "missing destination uri argument"; exit 1; }

    local source_uri="$1"
    local target_uri="$2"
    local specific_key="$3"

    if [ -n "$specific_key" ]; then
        _redis_dump_one_key $source_uri $target_uri $specific_key

    else
        local keys=( $(redis-cli -u $source_uri keys '*') )

        for key in ${keys[@]}; do
            _redis_dump_one_key $source_uri $target_uri $key
        done
    fi

}

_redis_dump_one_key() {
    [ -z "$1" ] && { echo  "missing source uri argument"; exit 1; }
    [ -z "$2" ] && { echo  "missing destination uri argument"; exit 1; }

    local source_uri="$1"
    local target_uri="$2"
    local key="$3"

    local exists=$(redis-cli -u $target_uri exists "$key")

    if [ $exists -eq 0 ]; then
        local ttl=$(redis-cli -u $source_uri --raw TTL "$key") # expire time of the key

        if [ $ttl -gt 0 ]; then
            redis-cli -u $source_uri --raw DUMP "$key" | head -c-1 \
                | redis-cli -u $target_uri -x RESTORE "$key" "$ttl" # restore key with expiration time
        else
            redis-cli -u $source_uri --raw DUMP "$key" | head -c-1 \
                | redis-cli -u $target_uri -x RESTORE "$key" 0 # restore key with no expiration time
        fi
    fi
}

# if [ -x "$(command -v rg)" ]; then
    _rg_file() {
        # search for files
        local file_pattern="${1:-*}"

        rg --files | rg "$file_pattern" "${@:2}"
    }

    _rg_file_pattern() {
        # search for pattern in files
        local search_pattern="$1"
        local file_pattern="${2:-*}"

        rg -g "$file_pattern" "$search_pattern" "${@:3}"
    }
# fi

if [ -x "$(command -v wmctrl)" ]; then
    _wm_current_desk() {
        echo "$(wmctrl -d | grep \* | awk '{print $1}')"
    }
fi
