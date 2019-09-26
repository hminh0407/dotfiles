# utilities { # contain base functions for other scripts. Need to be in the first order
    _append_to_file_if_not_exist() {
        [ -z "$1" ] && { echo  "missed param 'line'"; exit 1; }
        [ -z "$2" ] && { echo  "missed param 'file'"; exit 1; }
        local line="$1"
        local file="$2"
        grep -qF -- "$line" "$file" || echo "$line" >> "$file"
    }

   _is_in_git_repo() { # return non-zero status if the current directory is not managed by git
        git rev-parse HEAD > /dev/null 2>&1
   }

    _is_in_tmux() { # check if shell is in tmux session
        [ -n "$TMUX" ]
    }

    _is_service_exist() {
        # https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
        local service="$1"
        [ -x "$(command -v $service)" ]
    }

    # clone git if not exist, pull latest code if exist
    _git_clone() {
        [ -z "$1" ] && { echo "missed param 'repo'"; exit 1; }
        [ -z "$2" ] && { echo "missed param 'localRepo'"; exit 1; }
        local repo="${1}"
        local localRepo="${2}"
        # git clone ${repo} ${localRepo} 2> /dev/null || git -C ${localRepo} pull
        git -C ${localRepo} pull || git clone --depth=1 --recursive ${repo} ${localRepo}
    }
# }

# desk {
if _is_service_exist "desk"; then
    _desk() { # list all pre-defined desk and cd to selected desk if possible
        if _is_service_exist fzf; then
            local desk=$(desk ls | fzf | awk '{print $1}')
            if [ -n "${desk:+1}" ]; then
                desk go $desk
            fi
        else
            desk ls && return
        fi
    }
fi
# }

# fzf {
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
    # "Nothing to see here, move along"
    _is_in_git_repo || return

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
  }

  _fzf_git_tag() { # show list and can select multiple
    # "Nothing to see here, move along"
    _is_in_git_repo || return

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
  }

# }

# gcloud {
if _is_service_exist gcloud; then
    _gcloud_compute() { # list of gcloud compute instances and describe selected instance if possible
        if _is_service_exist fzf; then
            local instance=$(gcloud compute instances list | fzf | awk '{print $1}')
            # if variable is set and not empty https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
            if [ -n "${instance:+1}" ]; then
                gcloud compute instances describe $instance
            fi
        else
            gcloud compute instances list && return
        fi
    }

    _gcloud_project() { # get current project
        gcloud config get-value project -q
    }

    _gcloud_sql() { # list of gcloud sql instances and describe selected instance if possible
        if _is_service_exist fzf; then
            local instance=$(gcloud sql instances list | fzf | awk '{print $1}')
            if [ -n "${instance:+1}" ]; then
                gcloud sql instances describe $instance
            fi
        else
            gcloud sql instances list && return
        fi
    }

    _gcloud_service() { # list all services offered by google
        if _is_service_exist fzf; then
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)' | fzf
        else
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)'
        fi

    }
fi
if _is_service_exist kubectl; then
    _kube_deployments() { # list of kubernetes deployment and describe selected item if possible
        if _is_service_exist fzf; then
            # local item=$(kubectl get deployment --no-headers -o custom-columns=NAME:.metadata.name | fzf | awk '{print $1}')
            local item=$(kubectl get deployment | fzf | awk '{print $1}')
            if [ -n "${item:+1}" ]; then
                kubectl describe deployment $item
            fi
        else
            kubectl get deployment --no-headers -o custom-columns=NAME:.metadata.name && return
        fi
    }

    _kube_ingress() { # list of kubernetes deployment and describe selected item if possible
        if _is_service_exist fzf; then
            # local item=$(kubectl get ingress --no-headers -o custom-columns=NAME:.metadata.name | fzf | awk '{print $1}')
            local item=$(kubectl get ingress | fzf | awk '{print $1}')
            if [ -n "${item:+1}" ]; then
                # NOTE: does not work if client version of kubectl is different with server version
                kubectl describe ingress $item
            fi
        else
            kubectl get ingress --no-headers -o custom-columns=NAME:.metadata.name && return
        fi
    }

    _kube_nodes() { # list of kubernetes nodes and describe selected item if possible
        if _is_service_exist fzf; then
            # local item=$(kubectl get node --no-headers -o custom-columns=NAME:.metadata.name | fzf | awk '{print $1}')
            local item=$(kubectl get node | fzf | awk '{print $1}')
            if [ -n "${item:+1}" ]; then
                kubectl describe node $item
            fi
        else
            kubectl get node --no-headers -o custom-columns=NAME:.metadata.name && return
        fi
    }

    _kube_services() { # list all kubernetes services and describe selected service if possible
        if _is_service_exist fzf; then
            # local item=$(kubectl get services --no-headers -o custom-columns=NAME:.metadata.name | fzf | awk '{print $1}')
            local item=$(kubectl get services | fzf | awk '{print $1}')
            if [ -n "${item:+1}" ]; then
                kubectl describe service $item
            fi
        else
            kubectl get services --no-headers -o custom-columns=NAME:.metadata.name && return
        fi
    }
fi
# }

# }
