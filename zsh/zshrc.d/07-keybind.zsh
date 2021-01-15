############################################### KEY BINDING ###########################################################
# Key Binding {

# alias {
alias_widget() LBUFFER+=$(_fzf_alias | join_lines)
zle -N alias_widget
bindkey '^f^p' alias_widget
# }

# Docker Container {
fdocker_container_widget() LBUFFER+=$(_fzf_docker_container | join_lines)
zle -N fdocker_container_widget
bindkey '^d^p' fdocker_container_widget
# }

# Docker Image {
fdocker_images_widget() LBUFFER+=$(_fzf_docker_images | join_lines)
zle -N fdocker_images_widget
bindkey '^d^i' fdocker_images_widget
# }

# Git Aliases {
fgit_a_widget() LBUFFER+=$(_fzf_git_alias | join_lines)
zle -N fgit_a_widget
bindkey '^g^p' fgit_a_widget
# }

# Git Branch {
fgit_b_widget() LBUFFER+=$(_fzf_git_branch | join_lines)
zle -N fgit_b_widget
bindkey '^g^b' fgit_b_widget
# }

# Git Tag {
fgit_t_widget() LBUFFER+=$(_fzf_git_tag | join_lines)
zle -N fgit_t_widget
bindkey '^g^t' fgit_t_widget
# }

# }

# Helper Functions {
join_lines() { # join multi-line output from fzf
    local item
    while read item; do
        echo -n "${(q)item} "
    done
}
# }

stty -ixon # disable Ctrl+S key
