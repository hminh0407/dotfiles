# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

# History {
    setopt BANG_HIST                 # Treat the '!' character specially during expansion.
    setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
    setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
    setopt SHARE_HISTORY             # Share history between all sessions.
    setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
    setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
    setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
    setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
    setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
    setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
    setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
    setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
    setopt HIST_BEEP                 # Beep when accessing nonexistent history.
# }

# Key Binding {
    bindkey '^ '         autosuggest-accept
    # bindkey '^[[A'       history-substring-search-up
    # bindkey '^[[B'       history-substring-search-down
    # bindkey -M vicmd 'k' history-substring-search-up
    # bindkey -M vicmd 'j' history-substring-search-down
# }

# =====================================================================================================================
# INTEGRATION
# =====================================================================================================================

isServiceExist () {
    [ -z "$1" ] && { logParamMissing "service"; exit 1; }
    local service="$1"
    # check if service exist and not an alias by checking its execute file location
    if service_loc="$(type -p "${service}")" || [[ -z $service_loc ]]; then
        return
    fi
    # a proper way to use bash function that return boolean: https://stackoverflow.com/a/43840545
    false
}

if isServiceExist direnv; then
    eval "$(direnv hook zsh)"
fi

if [ /etc/grc.zsh ]; then
    [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
