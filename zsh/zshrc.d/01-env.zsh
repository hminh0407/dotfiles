# Store all environment variables

export DOTFILES_DIR="$HOME/.dotfiles"
export DOTFILES_BIN_DIR="$DOTFILES_DIR/bin"
export DOTFILES_TMP_DIR="$DOTFILES_DIR/tmp"

# nvm zsh plugin config
export NVM_NO_USE=true
export NVM_LAZY_LOAD=true

# pager
export PAGER='less -RFX'

# tmux
export DISABLE_AUTO_TITLE='true' # tmuxp integration

# vim
export EDITOR='vi'
export VISUAL='vi'

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden" # use ripgrep as default search
