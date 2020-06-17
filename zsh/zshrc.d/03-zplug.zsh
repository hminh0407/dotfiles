source ~/.zplug/init.zsh

zplug "Aloxaf/fzf-tab" # https://github.com/Aloxaf/fzf-tab
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "MichaelAquilina/zsh-you-should-use" # https://github.com/MichaelAquilina/zsh-you-should-use

# Pretty minimal and fast zsh prompt: https://github.com/sindresorhus/pure
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "zsh-users/zsh-completions" # https://github.com/zsh-users/zsh-completions

# https://github.com/lukechilds/zsh-nvm
zplug "lukechilds/zsh-nvm" # https://github.com/lukechilds/zsh-nvm

zplug "plugins/kube-ps1", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
