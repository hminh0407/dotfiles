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

# https://coderwall.com/p/a3xreg/per-directory-zsh-config
# With this we can make .zsh_config file for each directory we want,
# and when we cd to that directory, zsh will read the .zsh_config file and use any configuration found in there
function chpwd() {
    local suffix="${1}"

    # if multiple version of zsh_config contains in folder, choose the specific version passed through as param
    if [ ! -z $suffix ]; then
        ln -sfn $PWD/.zsh_config_$suffix $PWD/.zsh_config
    fi

    if [ -r $PWD/.zsh_config ]; then
        source $PWD/.zsh_config
        echo "Loaded folder specific zsh config"
    else
        source $HOME/.zshrc
    fi
}

function sourceBash {
    # It is not easy to source bash file with bash_source using zsh properly. Check below stackoverflow link
    # https://unix.stackexchange.com/questions/479092/how-can-i-source-a-bash-script-containing-bash-source-from-zsh-shell/837256
    local bashSource="${1}"
    . <(awk '{gsub(/\${BASH_SOURCE\[0\]}/, FILENAME); print}' $bashSource)
}

sourceBash $(dirname ${(%):-%N})/scripts/base.sh


if isServiceExist direnv; then
    eval "$(direnv hook zsh)"
fi

if [ /etc/grc.zsh ]; then
    [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
