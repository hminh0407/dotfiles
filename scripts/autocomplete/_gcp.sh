_gcp() {
    local opts="$(gcp _opts_external)"
    COMPREPLY=($(compgen -W "$opts" "${COMP_WORDS[1]}"))
}

complete -F _gcp gcp
