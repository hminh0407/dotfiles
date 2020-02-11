# Store all environment variables

# general
export CUSTOM_SCRIPTS="$HOME/bin"
export PROJECT_CUSTOM_SCRIPTS="$HOME/.project"
export TMP_FOLDER="$HOME/tmp"

# nvm
export NVM_NO_USE=true # disable auload node https://github.com/lukechilds/zsh-nvm
export NVM_DIR="$HOME/.nvm"
export NODE_PATH=`npm root -g` # required for fx (https://github.com/antonmedv/fx/blob/master/DOCS.md)

# pager
# export PAGER='vi -'
export PAGER='less -RFX'

# pipenv
export PIPENV_VENV_IN_PROJECT="enabled"
    # make pipenv create venv in project folder

# tmux
export DISABLE_AUTO_TITLE='true' # tmuxp integration

# vim
export EDITOR='vi'
# export TERM="xterm-256color"
export VISUAL='vi'

# zfz
# export FZF_DEFAULT_COMMAND="ag --path-to-ignore ~/.ignore --hidden -l -g ''" # use ag (the_silver_searcher) as default search
export FZF_DEFAULT_COMMAND="rg --files --hidden" # use ripgrep as default search
# export FZF_DEFAULT_OPTS="--height 80% --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
