# history config
# check for more detail: https://www.soberkoder.com/better-zsh-history/
export HISTFILE=~/.zsh_history # set history file location
export HISTFILESIZE=1000000000 # increase history file size
export HISTSIZE=1000000000 # increase history file size
export SAVEHIST=$HISTSIZE # history memory file
export HISTTIMEFORMAT="[%F %T] " # time format

setopt INC_APPEND_HISTORY # Appends every command to the history file once it is executed
setopt EXTENDED_HISTORY # record the timestamp of each command
setopt HIST_FIND_NO_DUPS # no duplicate command
setopt HIST_IGNORE_ALL_DUPS

zstyle ':completion:*' menu select
