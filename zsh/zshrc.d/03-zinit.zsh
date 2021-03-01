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
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

zinit light Aloxaf/fzf-tab

zinit ice as"program" mv"httpstat.sh -> httpstat" pick"httpstat" atpull'!git reset --hard'
zinit light b4b4r07/httpstat

# sharkdp/bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# dandavision/delta
zinit ice as"command" from"gh-r" mv"delta* -> delta" pick"delta/delta"
zinit light dandavison/delta

zinit light lukechilds/zsh-nvm
# zinit light supercrabtree/k

### oh-my-zsh plugins ###
zinit snippet OMZP::urltools

