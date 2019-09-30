  # Buku { # (not use much)
    # fbrowser-bookmark_widget() LBUFFER+=$(fbrowser-bookmark | join_lines)
    # zle -N fbrowser-bookmark_widget
    # bindkey '^f^b' fbrowser-bookmark_widget
  # }

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
