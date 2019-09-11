# Helper Functions {

  # Docker {
    docker_c() { # docker container
      echo $(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Ports}}" | fzf --multi | awk '{print $1}')
    }

    docker_i() { # docker image
      echo $(docker images | fzf --multi | awk '{print $1":"$2}')
    }
  #}

  # Git {
    # Will return non-zero status if the current directory is not managed by git
    is_in_git_repo() {
      git rev-parse HEAD > /dev/null 2>&1
    }

    git_b() { # git branch helper function
      # "Nothing to see here, move along"
      is_in_git_repo || return

      # Pass the list of the branches to fzf
      # - "{}" in preview option is the placeholder for the highlighted entry
      # - Preview window can display ANSI colors, so we enable --color=always
      # - We can terminate `git show` once we have $LINES lines
      git branch | awk '{$1=$1};1' |
        # fzf-tmux --multi --preview-window right:70% \
        fzf --multi --preview-window right:70% \
            --preview 'git show --color=always {} | head -'$LINES
      # git branch --all | awk '{$1=$1};1' | fzf --multi # incase above command does not work
    }

    git_t() {
      # "Nothing to see here, move along"
      is_in_git_repo || return

      # Pass the list of the tags to fzf-tmux
      # - "{}" in preview option is the placeholder for the highlighted entry
      # - Preview window can display ANSI colors, so we enable --color=always
      # - We can terminate `git show` once we have $LINES lines
      git tag --sort -version:refname |
        # fzf-tmux --multi --preview-window right:70% \
        fzf --multi --preview-window right:70% \
                 --preview 'git show --color=always {} | head -'$LINES
      # git tag --sort -version:refname | fzf --multi # incase above command does not work
    }
  # }

# }

# Key Binding {
  bind '"\er": redraw-current-line'

  # Docker { # cannot bind C-d as it is binded to terminate shell, use same prefix with git
    bind '"\C-g\C-p": "$(docker_c)\e\C-e\er"' # docker container
    bind '"\C-g\C-i": "$(docker_i)\e\C-e\er"' # docker images
  # }

  # Git {
    bind '"\C-g\C-b": "$(git_b)\e\C-e\er"' # git branch
    bind '"\C-g\C-t": "$(git_t)\e\C-e\er"' # git tag
  # }

# }
