# Store all environment variables

# general
export CUSTOM_SCRIPTS="$HOME/bin"
export PROJECT_CUSTOM_SCRIPTS="$HOME/.project"
export TMP_FOLDER="$HOME/tmp"

# nvm
export NVM_NO_USE=true # disable auload node https://github.com/lukechilds/zsh-nvm
export NVM_DIR="$HOME/.nvm"

# pager
# export PAGER='vim -'
export PAGER='less -RFX'

# tmux
export DISABLE_AUTO_TITLE='true' # tmuxp integration

# vim
export EDITOR='vim'
# export TERM="xterm-256color"
export VISUAL='vim'

# zfz
# export FZF_DEFAULT_COMMAND="ag --path-to-ignore ~/.ignore --hidden -l -g ''" # use ag (the_silver_searcher) as default search
export FZF_DEFAULT_COMMAND="rg --files --hidden" # use ripgrep as default search
# export FZF_DEFAULT_OPTS="--height 80% --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
