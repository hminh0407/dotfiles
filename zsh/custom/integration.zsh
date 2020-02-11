# Store all package that need to be integrated with shell

# bindkey -v

# Define modules to integrate with
DESK="$DESK_ENV"
FZF="$HOME/.fzf.zsh"
# POWERLINE="/usr/share/powerline/bindings/zsh/powerline.zsh"

DIRENV="$(direnv hook zsh)"

SOURCE_MODULES=($FZF $DESK)

# Load integration modules
for module in "$SOURCE_MODULES[@]"; do [ -f $module ] && source $module; done

# eval modules need to be checked carefully
_is_service_exist direnv && eval $DIRENV

