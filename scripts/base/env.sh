# Store all environment variables

# general
export CUSTOM_SCRIPTS="$HOME/bin"
export PROJECT_CUSTOM_SCRIPTS="$HOME/.project"

# nvm
export NVM_NO_USE=true # disable auload node https://github.com/lukechilds/zsh-nvm
export NVM_DIR="$HOME/.nvm"

# pager
# export PAGER='vim -'

# tmux
export DISABLE_AUTO_TITLE='true' # tmuxp integration

# vim
export EDITOR='vim'
export TERM="xterm-256color"
export VISUAL='vim'

# zfz
# export FZF_DEFAULT_COMMAND="ag --path-to-ignore ~/.ignore --hidden -l -g ''" # use ag (the_silver_searcher) as default search
export FZF_DEFAULT_COMMAND="rg --files --hidden" # use ripgrep as default search
# set color theme
# Press F1 to open the file with less without leaving fzf
# Press CTRL-Y to copy the line to clipboard without leaving fzf (requires xclip)
export FZF_DEFAULT_OPTS="--color=16 --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | xclip -selection c)'"

