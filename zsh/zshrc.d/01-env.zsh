# Store all environment variables

export DOTFILES_DIR="$HOME/.dotfiles"
export DOTFILES_BIN_DIR="$DOTFILES_DIR/bin"
export DOTFILES_TMP_DIR="$DOTFILES_DIR/tmp"

export CUSTOM_SCRIPTS_DIR="$HOME/.scripts/custom"

if [ ! -d $DOTFILES_DIR ]; then
  mkdir -p $DOTFILES_DIR
fi

if [ ! -d $DOTFILES_BIN_DIR ]; then
  mkdir -p $DOTFILES_BIN_DIR
fi

if [ ! -d $DOTFILES_TMP_DIR ]; then
  mkdir -p $DOTFILES_TMP_DIR
fi

if [ ! -d $CUSTOM_SCRIPTS_DIR ]; then
  mkdir -p $CUSTOM_SCRIPTS_DIR
fi

# nvm zsh plugin config
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'vi' 'nvim')
export NVM_NO_USE=false
export NVM_AUTO_USE=false

# pager
export PAGER='less -RFX'

# tmux
export DISABLE_AUTO_TITLE='true' # tmuxp integration

# vim
export EDITOR='vi'
export VISUAL='vi'

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden" # use ripgrep as default search

export COLORTERM="truecolor"

export ANSIBLE_NOCOWS=1

export GUI_SUPPORT=$(type Xorg > /dev/null && echo 1)

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
  # run docker with rootless context
