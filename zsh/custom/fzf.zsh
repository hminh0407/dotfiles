############################################### KEY BINDING ###########################################################
# Key Binding {
  # alias {
    alias_widget() LBUFFER+=$(_fzf_alias | join_lines)
    zle -N alias_widget
    bindkey '^f^p' alias_widget
  # }

  # Buku {
    # fbrowser-bookmark_widget() LBUFFER+=$(fbrowser-bookmark | join_lines)
    # zle -N fbrowser-bookmark_widget
    # bindkey '^f^b' fbrowser-bookmark_widget
  # }

  # Docker Container {
    fdocker_container_widget() LBUFFER+=$(_fzf_docker_container | join_lines)
    zle -N fdocker_container_widget
    bindkey '^d^p' fdocker_container_widget
  # }

  # Docker Image {
    fdocker_images_widget() LBUFFER+=$(_fzf_docker_images | join_lines)
    zle -N fdocker_images_widget
    bindkey '^d^i' fdocker_images_widget
  # }

  # Git Aliases {
    fgit_a_widget() LBUFFER+=$(_fzf_git_alias | join_lines)
    zle -N fgit_a_widget
    bindkey '^g^p' fgit_a_widget
  # }

  # Git Branch {
    fgit_b_widget() LBUFFER+=$(_fzf_git_branch | join_lines)
    zle -N fgit_b_widget
    bindkey '^g^b' fgit_b_widget
  # }

  # Git Tag {
    fgit_t_widget() LBUFFER+=$(_fzf_git_tag | join_lines)
    zle -N fgit_t_widget
    bindkey '^g^t' fgit_t_widget
  # }

# }

# Helper Functions {
  join_lines() { # join multi-line output from fzf
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

