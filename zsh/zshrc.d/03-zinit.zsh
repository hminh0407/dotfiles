# zinit ice blockf atpull'zinit creinstall -q .'
# zinit light zsh-users/zsh-completions

# zinit ice atinit"zicompinit; zicdreplay"
# zinit light zdharma/fast-syntax-highlighting
# zinit light zsh-users/zsh-autosuggestions

# turbo mode loading 3 essentials plugins
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions

# zinit wait lucid light-mode for \
#   atinit"zicompinit; zicdreplay" \
#       zdharma/fast-syntax-highlighting \
#   atload"_zsh_autosuggest_start" \
#       zsh-users/zsh-autosuggestions \
#   blockf atpull'zinit creinstall -q .' \
#       zsh-users/zsh-completions

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

zinit light Aloxaf/fzf-tab

# zinit ice as"program" mv"httpstat.sh -> httpstat" pick"httpstat" atpull'!git reset --hard'
# zinit light b4b4r07/httpstat

# sharkdp/bat
# zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
# zinit light sharkdp/bat

# dandavision/delta
zinit ice as"command" from"gh-r" mv"delta* -> delta" pick"delta/delta"
zinit light dandavison/delta

zinit light lukechilds/zsh-nvm

### oh-my-zsh plugins ###
# zinit snippet OMZP::urltools

zinit ice load'[[ $GUI_SUPPORT = 1 ]]' lucid atload"AUTO_NOTIFY_IGNORE+=('sleep' 'vi' 'dg'); AUTO_NOTIFY_THRESHOLD=30"
zinit light MichaelAquilina/zsh-auto-notify

# zinit ice as"command" from"gh-r" ver"v0.5.0" bpick"*.tar.gz" pick"bin/nvim" mv"nvim* -> nvim"
# zinit light neovim/neovim

zinit ice as"command" from"gh-r" ver="3.2a" atclone"cd tmux-3.2a && ./configure && make && sudo make install"
zinit light tmux/tmux

# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode
#
# # For postponing loading `fzf`, make it compatible with https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
# # https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
# zinit ice lucid wait
# zinit snippet OMZP::fzf

# zinit ice as"program" from"gh-r" bpick"*_Linux_x86_64.tar.gz" pick"k9s"
# zinit light derailed/k9s
