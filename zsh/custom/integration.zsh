# Store all package that need to be integrated with shell

# bindkey -v

# Define modules to integrate with
FZF="${HOME}/.fzf.zsh"

DIRENV="$(direnv hook zsh)"

SOURCE_MODULES=($FZF)

# Load integration modules
for module in "$SOURCE_MODULES[@]"; do [ -f $module ] && source $module; done

# eval modules need to be checked carefully
isServiceExist direnv && eval $DIRENV
