# utilities { # Need to be in the first order
    _append_to_file_if_not_exist () {
        [ -z "$1" ] && { echo  "missed param 'line'"; exit 1; }
        [ -z "$2" ] && { echo  "missed param 'file'"; exit 1; }
        local line="$1"
        local file="$2"
        grep -qF -- "$line" "$file" || echo "$line" >> "$file"
    }

    _is_service_exist () {
        # https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
        local service="${1}"
        [ -x "$(command -v $service)" ]
    }

    # clone git if not exist, pull latest code if exist
    _git_clone () {
        [ -z "$1" ] && { echo "missed param 'repo'"; exit 1; }
        [ -z "$2" ] && { echo "missed param 'localRepo'"; exit 1; }
        local repo="${1}"
        local localRepo="${2}"
        # git clone ${repo} ${localRepo} 2> /dev/null || git -C ${localRepo} pull
        git -C ${localRepo} pull || git clone --depth=1 --recursive ${repo} ${localRepo}
    }
# }

# gcloud {
if _is_service_exist gcloud; then
    _g_compute() { # list of gcloud compute instances
        local instance
        if _is_service_exist fzf; then
            instance=$(gcloud compute instances list | fzf | awk '{print $1}')
        else
            gcloud compute instances list && return
        fi

        # if variable is set and not empty https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
        if [ -n "${instance:+1}" ]; then
            gcloud compute instances describe $instance
        fi
    }

    _g_sql() { # list of gcloud sql instances
        local instance
        if _is_service_exist fzf; then
            instance=$(gcloud sql instances list | fzf | awk '{print $1}')
        else
            gcloud sql instances list && return
        fi

        if [ -n "${instance:+1}" ]; then
            gcloud sql instances describe $instance
        fi
    }

    _g_service() {
        if _is_service_exist fzf; then
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)' | fzf
        else
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)'
        fi

    }
fi
if _is_service_exist kubectl; then
    _k_nodes() { # list of kubernetes nodes
        if _is_service_exist fzf; then
            node=$(kubectl get node --no-headers -o custom-columns=NAME:.metadata.name | fzf | awk '{print $1}')
        else
            kubectl get node --no-headers -o custom-columns=NAME:.metadata.name && return
        fi

        if [ -n "${node:+1}" ]; then
            kubectl describe node $node
        fi
    }
fi
# }

# }
