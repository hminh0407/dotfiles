# === Base ===
# contain base functions for other scripts. Need to be in the first order

_append_to_file_if_not_exist() {
    [ -z "$1" ] && { echo  "missed param 'line'"; exit 1; }
    [ -z "$2" ] && { echo  "missed param 'file'"; exit 1; }
    local line="$1"
    local file="$2"
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
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

# ===============================================
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

if [ -x "$(command -v ffmpeg)" ]; then
    _ffmpeg_add_sub_to_video() {
        # adds the subtitles to the video as a separate optional (and user-controlled) subtitle track.
        # create new video with embedded subtitle
        #https://stackoverflow.com/a/33289845/1530178
        # only support mkv video and srt sub

        local video="$1"
        local sub="$2"
        local videoName=$(basename $video | cut -d '.' -f1)
        local videoExtension=$(basename $video | cut -d '.' -f2)

        # this will add an additional subtitle with metadata 'unknown'
        ffmpeg -i $video -i $sub \
            -map 0:0 -map 0:1 -map 1:0 \
            -c:v copy -c:a copy -c:s srt \
            "${videoName}_formatted.$videoExtension"

        # to add multiple subtitles with proper metadata use below script instead. Note that it is intended to run manually
        # ffmpeg -i $video -i $sub1 -i$sub2 ... \
        #     -map 0:v -map 0:a -map 1 -map 2 \
        #     -c:v copy -c:a copy -c:s srt \
        #     -metadata:s:s:0 language=$lang1 -metadata:s:s:1 language=$lang2 ...\
        #     "${videoName}_formatted.$videoExtension"
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
        git la | fzf | awk '{split($0,a,"="); print a[1]}'
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

    _gcloud_compute() { # list of gcloud compute instances and describe selected instance if possible
        local fields=(
            'name'
            'zone.basename()'
            'machineType.basename()'
            'scheduling.preemptible.yesno(yes=true, no='')'
            'networkInterfaces[0].networkIP:label=INTERNAL_IP'
            'networkInterfaces[0].accessConfigs[0].natIP:label=EXTERNAL_IP'
            'status'
            'labels.list()'
        )
        local format_str="table($(_join_by ',' ${fields[@]}))"

        local filter="$1"

        if [ -z $filter ]; then
            gcloud compute instances list --format="$format_str"
        else
            gcloud compute instances list --format="$format_str" --filter="$filter"
        fi
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

    _gcloud_compute_name_filter_no_label() { # return name list of all instances that do not have a specific label
        [ -z "$1" ] && { echo  "missing argument"; exit 1; }

        local label="$1"

        gcloud compute instances list --filter="-labels.${label}:*" --format="value(name)"
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

        local instance="$1"
        local label_key="$2"
        local label_value="$3"

        gcloud compute instances add-labels "$instance" --labels="$label_key=$label_value"
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

    _gcloud_deployment() { # list of gcloud compute instances and describe selected instance if possible
        if [ -x "$(command -v fzf)" ]; then
            gcloud deployment-manager deployments list | fzf | awk '{print $1}' | xargs -r gcloud compute instances describe
        else
            gcloud deployment instances list && return
        fi
    }

    _gcloud_disk() {
        local filter="$1"

        if [ -z $filter ]; then
            gcloud compute disks list
        else
            gcloud compute disks list --filter="$filter"
        fi
    }

    _gcp_log_kevent() {
        # Example
        # _gcp_log_event_hpa \
        #     "jsonPayload.involvedObject.name=<project_name>" \
        #     "timestamp>=\"$(date --iso-8601=s --date='7 days ago')\""
        local filter=(
            "resource.type=gke_cluster"
            "jsonPayload.kind=Event"
            # "timestamp>=\"$(date --iso-8601=s --date='30 minutes ago')\"" # latest 30 minutes
            # "jsonPayload.source.component=horizontal-pod-autoscaler"
            # "severity=WARNING" # check for specific severity
            # "resource.labels.cluster_name=vexere"
            # "jsonPayload.metadata.name:<pod_name>" # check specific pod pattern
            # "jsonPayload.reason=FailedGetResourceMetric" # check for specific reason
            "$@"
        )
        local filterStr=$( _join_by ' ' "${filter[@]}" )

        local resultField=(
            "'resource.labels.cluster_name'"
            # "'resource.labels.location'"
            # "'resource.labels.project_id'"
            # "'resource.type'"
            "'jsonPayload.involvedObject.namespace'"
            "'jsonPayload.involvedObject.kind'"
            "'jsonPayload.involvedObject.name'"
            # "'jsonPayload.metadata.name'"
            "'jsonPayload.reason'"
            "'jsonPayload.message'"
            "'severity'"
            "'timestamp'"
            "'kind'"
        )
        local resultFieldStr=$(_join_by ',' "${resultField[@]}")

        gcloud logging read "$filterStr" --limit 9000 --format json \
        | fx ".map( x => [$resultFieldStr].reduce( (acc,cur) => { acc[cur] = require('lodash').get(x, cur); return acc }, {} ))"
    }

    _gcp_log_event_hpa() {
        _gcp_log_kevent "jsonPayload.source.component=horizontal-pod-autoscaler" "$@"
    }

    _gcloud_project() { # get current project
        gcloud config get-value project -q
    }

    _gcloud_sql() { # list of gcloud sql instances and describe selected instance if possible
        if [ -x "$(command -v fzf)" ]; then
            local instance=$(gcloud sql instances list | fzf | awk '{print $1}')
            if [ -n "${instance:+1}" ]; then
                gcloud sql instances describe $instance
            fi
        else
            gcloud sql instances list && return
        fi
    }

    _gcloud_service() { # list all services offered by google
        if [ -x "$(command -v fzf)" ]; then
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)' | fzf
        else
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)'
        fi

    }
fi

    # _gitlab_pr_create() {
    #     # Create gitlab pr for
    #     # * current branch (pwd git folder)
    #     # * merge to default branch
    #     # * in current repo (pwd git folder)

    #     local endpoint="$GITLAB_HOST/api/$GITLAB_API_VERSION/projects"
    #     local token="$GITLAB_TOKEN"

    #     local headers=(
    #        Authorization:"Bearer $token"
    #     )

    #     local branch="$(git br-current)" # get current git branch (git alias)
    #     local repo="$(git repo)" # get current repo (git alias)
    #     local encodedRepo="$(_urlencode $repo)" # get current repo (git alias)
    #     local targetBranch="$(_gitlab_repo_get_default_branch $repo)" # get the default branch of repo
    #     local assigneeId="$(_gitlab_repo_get_creator_id $repo)" # assign to creator by default
    #     local title="$(_urlencode "$(git log-last-comment)")" # get comment from last commit (git alias)

    #     local params=(
    #         "source_branch=$branch"
    #         "target_branch=$targetBranch"
    #         "assignee_id=$assigneeId"
    #         "title=$title"
    #         "remove_source_branch=true"
    #         "squash=true"
    #         "$@"
    #     )
    #     local queryStr=$(_join_by '&' "${params[@]}")

    #     local url="$endpoint/$encodedRepo/merge_requests?$queryStr"

    #     http POST \
    #         "$url" \
    #         "${headers[@]}"
    # }

if [ -x "$(command -v kubectl)" ]; then
    _kube_get_list() {
        local service="$1"
        local mode="${2:-default}"

        case "$mode" in
            describe*) # describe the selected item
                if [ -x "$(command -v fzf)" ]; then echo "fzf is not exist, this mode is not supported" && return; fi

                kubectl get $service ${@:3} | fzf | awk '{print $1}' | xargs -r kubectl describe $service
                ;;
            name*) # copy name of selected item to clipboard
                if [ -x "$(command -v fzf)" ]; then echo "fzf is not exist, this mode is not supported" && return; fi

                kubectl get $service ${@:3} | fzf | awk '{print $1}' ORS='' | xclip -selection c
                    # get list of items
                    # select by fzf
                    # get the value of 1 column and join lines (by default fzf will add an additional new line to selected item)
                    # copy the selected item to clipboard
                ;;
            *)
                kubectl get $service ${@:3} && return
        esac
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

    _kube_deployment() { # list of kubernetes deployment and describe selected item if possible
        local mode="$1"

        _kube_get_list "deployment" $mode
    }

    _kube_deployment_name() {
        kubectl get deployment -o custom-columns="NAME:metadata.name" --no-headers
    }

    _kube_event() { # list of kubernetes deployment and describe selected item if possible
        local mode="$1"

        _kube_get_list "event" $mode
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

    _kube_hpa() {
        local mode="$1"

        _kube_get_list "hpa" $mode
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

    _kube_ingress() { # list of kubernetes deployment and describe selected item if possible
        local mode="$1"

        _kube_get_list "ingress" $mode
    }

    _kube_node() { # list of kubernetes nodes and describe selected item if possible
        local mode="$1"

        _kube_get_list "node" $mode
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

    _kube_pod() { # list all pod in current context and current namespace
        local mode="${1:-default}"

        _kube_get_list "pod" $mode -owide --show-labels

        # wip
        # k get pod -o json | jq -r '(["NAME","STATUS"] | (., map(length*"-"))), (.items[] | [.metadata.name, .status.phase]) | @tsv'
    }

    _kube_pod_all() { # list all pod in all context and all namespace
        local mode="${1:-default}"
        local current_context="$(kubectl config current-context)"
        local contexts=( $(_kube_context 'name') )

        local pod=$(
            kubectl get pod -owide --all-namespaces | head -n 1 |  awk '{print "CONTEXT", $0}';
                # get the header row
                # add header 'CONTEXT' at the beginning

            for c in ${contexts[@]}; do
                kubectx $c >/dev/null && _kube_get_list "pod" $mode -owide --no-headers --all-namespaces | awk '{print "'$c'", $0}'
                    # change context
                    # get list of pod
                    # add column context at the beginning
            done
        )
        kubectx $current_context >/dev/null # change back to current context

        echo $pod | column -t
    }

    _kube_pod_inactive() {
        local mode="${1:-default}"

        _kube_get_list "pod" $mode --field-selector="status.phase!=Running,status.phase!=Succeeded" --all-namespaces
    }

    _kube_pod_usage () {
        # bash function to track k8s pod usage
        # example output
        #
        # NAMESPACE NAME             CPU_USAGE(cores) RAM_USAGE(bytes) REQUESTED_CPU REQUESTED_RAM LIMITTED_CPU LIMITTED_RAM
        # default   canary-ams       0m               61Mi             100m          128Mi         <none>       1Gi
        # default   canary-ams-react 0m               22Mi             100m          <none>        <none>       <none>

        local namespace="${1:-default}"
        local pod_detail_custom_columns=(
            'NAMESPACE:.metadata.namespace'
            'NAME:.metadata.name'
            'REQUESTED_CPU:.spec.containers[*].resources.requests.cpu'
            'REQUESTED_RAM:.spec.containers[*].resources.requests.memory'
            'LIMITTED_CPU:.spec.containers[*].resources.limits.cpu'
            'LIMITTED_RAM:.spec.containers[*].resources.limits.memory'
            'NODE:.spec.nodeName'
            # 'created:.metadata.creationTimestamp'
        )
        local pod_defail_custom_columns_str=$(_join_by ',' ${pod_detail_custom_columns[@]})

        local pod_usage="$(kubectl top pods --namespace=$namespace --no-headers | sort -k 1,1)" # sort first column to make sure rows are consistent
        local pod_detail="$(kubectl get pods --namespace=$namespace --no-headers -o custom-columns="$pod_defail_custom_columns_str" | sort -k 2,2)" # sort first column to make sure rows are consistent

        local header="NAMESPACE NAME CPU_USAGE(cores) RAM_USAGE(bytes) REQUESTED_CPU REQUESTED_RAM LIMITTED_CPU LIMITTED_RAM NODE"
        local data="$(join -1 1 -2 2 -o '2.1,2.2,1.2,1.3,2.3,2.4,2.5,2.6,2.7' <(echo $pod_usage) <(echo $pod_detail) | sort -n -k 4,4 -k 2,2)"
            # join 2 data from $pod_usage and $pod_detail on pod_usage.column1 = pod_detail.column1
            # order columns with -o
            # use `sort -k 4,4 -k 2,2` to sort by the 4rd column (RAM_USAGE), 2nd column (NAME)

        ( echo $header ; echo $data ) | column -t
            # combine header and data
            # use `column -t` to align column for pretty output
    }

    _kube_service() { # list all kubernetes services and describe selected service if possible
        local mode="$1"

        _kube_get_list "services" $mode
    }

fi

if [ -x "$(command -v http)" ]; then
    _get() {
        echo $@
        _http GET "$@"
    }

    _post_form() {
        _http --form POST "$@"
    }

    _http()  {
        # note that below are just cosmetic for output format, should be set only
        # when running isolated request, do not use it for scripting
        local result_type="${result_type:-body}" # should default body
        local pretty="${pretty:-none}" # should default none
        local pager="${pager:-''}"

        local less_pager="less -RFX"
        local vim_pager="vi -c 'set ft=json | set foldlevel=9' -" # should only use with result_type=body & pretty=format

        if [ "$pager" = "vim" ]; then
            http --$result_type --pretty="format" "$@" | eval "$vim_pager" # has to use eval or else vim does not work as expected
        elif [ "$pager" = "less" ]; then
            http --$result_type --pretty="all" "$@" | $less_pager
        else
            http --verbose --$result_type --pretty=$pretty "$@"
        fi
    }
fi

# _redis_copy_all(){
#     # copy all redis keys from one server to another server
#     local source_host="$1"
#     local source_port="$2"

#     local target_host="$3"
#     local target_port="$4"

#     local keys=( $(redis-cli -u $source_urikeys '*') )

#     for key in ${keys[@]}; do

#         local ttl=$(redis-cli -u $source_uri--raw TTL "$key") # expire time of the key

#         if [ $ttl -gt 0 ]; then
#             redis-cli -u $source_uri--raw DUMP "$key" | head -c-1 \
#                 | redis-cli -u $target_uri -x RESTORE "$key" "$ttl" # restore key with expiration time
#         else
#             redis-cli -u $source_uri--raw DUMP "$key" | head -c-1 \
#                 | redis-cli -u $target_uri -x RESTORE "$key" 0 # restore key with no expiration time
#         fi

#     done
# }

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

if [ -x "$(command -v shnsplit)" ]; then
    _splitFlac() {
        [ -z "$1" ] && { echo  "missing cue file"; exit 1; }
        [ -z "$2" ] && { echo  "missing flac file"; exit 1; }

        local cueFile="$1"
        local flacFile="$2"

        shnsplit -f $cueFile -t %t-%p-%a -o flac $flacFile
    }
fi

if [ -x "$(command -v youtube-dl)" ]; then
    _youtube_download_video_mkv() {
        # download youtube video as mkv
        local url="$1"
            # youtube video url. ex: https://www.youtube.com/watch?v=LQRAfJyEsko

        youtube-dl \
            --format 'bestvideo[height=1080]+bestaudio' \
            --write-sub --sub-lang en,en_US,en_GB,en-US,en-GB \
            --merge-output-format mkv --embed-sub \
            -o '%(title)s.%(ext)s' \
            $url
    }

    _youtube_download_sub() {
        # download youtube video subtitle only
        local url="$1"
        local subLanguage="${2:-en,en_US,en_GB,en-US,en-GB}" # default to download english sub

        youtube-dl \
            --write-sub --sub-lang $subLanguage \
            --skip-download \
            $url
    }
fi

