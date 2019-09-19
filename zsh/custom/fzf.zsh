############################################### KEY BINDING ###########################################################
# Key Binding {
  # alias {
    alias-widget() LBUFFER+=$(falias | join-lines)
    zle -N alias-widget
    bindkey '^f^l' alias-widget
  # }

  # Buku {
    # fbrowser-bookmark-widget() LBUFFER+=$(fbrowser-bookmark | join-lines)
    # zle -N fbrowser-bookmark-widget
    # bindkey '^f^b' fbrowser-bookmark-widget
  # }

  # Docker Container {
    fdocker_container-widget() LBUFFER+=$(fdocker_container | join-lines)
    zle -N fdocker_container-widget
    bindkey '^d^p' fdocker_container-widget
  # }

  # Docker Image {
    fdocker_images-widget() LBUFFER+=$(fdocker_images | join-lines)
    zle -N fdocker_images-widget
    bindkey '^d^i' fdocker_images-widget
  # }

  # Git Aliases {
    fgit_a-widget() LBUFFER+=$(fgit_a | join-lines)
    zle -N fgit_a-widget
    bindkey '^g^l' fgit_a-widget
  # }

  # Git Branch {
    fgit_b-widget() LBUFFER+=$(fgit_b | join-lines)
    zle -N fgit_b-widget
    bindkey '^g^b' fgit_b-widget
  # }

  # Git Tag {
    fgit_t-widget() LBUFFER+=$(fgit_t | join-lines)
    zle -N fgit_t-widget
    bindkey '^g^t' fgit_t-widget
  # }

# }

# Helper Functions {
  falias() {alias | fzf | awk '{split($0,a,"="); print a[1]}'}

  # fbrowser-bookmark() { # search and open browser bookmark
  #   # 1. list all bookmark with format N=40 (url,title and tag without db index)
  #   # 2. pipe the result to fzf for fuzzy search
  #   # 3. extract the url with awk
  #   # 4. open url with xdg-open
  #   buku --suggest -p --format 40 | fzf | awk '{print $1}' | xargs xdg-open
  # }

  fdocker_container() {
    # echo $(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Ports}}" | fzf --multi | awk '{print $1}')
    local ps=$(docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Ports}}" | fzf --multi | awk '{print $1}')
    if [ -n "${ps:+1}" ]; then echo $ps; fi
  }

  fdocker_images() {
    local image=$(docker images | fzf --multi | awk '{print $1":"$2}')
    if [ -n "${image:+1}" ]; then echo $image; fi
  }

  fgit_a() { # show all git alias
    git la | fzf | awk '{split($0,a,"="); print a[1]}'
  }

  fgit_b() { # git branch helper function
    # "Nothing to see here, move along"
    is_in_git_repo || return

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
    git branch --all | awk '{$1=$1};1' | fzf --multi # in case above script don't work
  }

  fgit_t() { # git tag helper function
    # "Nothing to see here, move along"
    is_in_git_repo || return

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

  is_in_git_repo() { # return non-zero status if the current directory is not managed by git
    git rev-parse HEAD > /dev/null 2>&1
  }

  join-lines() { # join multi-line output from fzf
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }
# }

### System ###

############################################### CHROME ################################################################
# fchrome-history() {
#   local cols sep history_dir
#   cols=$(( COLUMNS / 3 ))
#   sep='{::}'
#   history_dir=~/.config/chromium/Default/History

#   yes | cp -rf $history_dir /tmp/h

#   sqlite3 -separator $sep /tmp/h \
#     "select substr(title, 1, $cols), url
#      from urls order by last_visit_time desc" |
#   awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
#   fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs xdg-open
# }

