# Setup global path for custom scripts
declare EXPORT_PATH="$PATH"
declare KREW_PATH="${KREW_ROOT:-$HOME/.krew}/bin"
declare PATH_MODULES=($DOTFILES_BIN_DIR $KREW_PATH)

for module in ${PATH_MODULES[@]}; do
    if [ -d "$module" ] && [[ ":$EXPORT_PATH:" != *":$module:"* ]]; then
        EXPORT_PATH="${EXPORT_PATH:+"$EXPORT_PATH:"}$module"
    fi
done
export PATH=$EXPORT_PATH

# # Setup scripts that need to be sourced
# FZF="$HOME/.fzf.zsh"
# SOURCE_MODULES=($FZF)
# for module in "$SOURCE_MODULES[@]"; do [ -f $module ] && source $module; done

# Setup hook
cd() { # override cd to add hook
    builtin cd "$@"
    if [ -n "$TMUX" ]; then
        # check if is in tmux session, then rename current window to current dir name
        tmux rename-window $(basename $(pwd))
    fi
}

rg() { # override rg to invoke pager as default
    if [ -t 1 ]; then
        command rg -p "$@" | less -RFX
    else
        command rg "$@"
    fi
}

# seting env EDITOR=vim make zsh shell misbehave, it always use vi modes
# do the trick to make it work as normal. Check for more detail http://matija.suklje.name/zsh-vi-and-emacs-modes
bindkey -e
