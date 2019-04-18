### Pet Function ###
# This file contain utils functions for pet snippet manager

# register previous command to pet
pet-prev() {
    PREV=$(fc -lrn | head -n 2 | tail -n 1)
    sh -c "pet new `printf %q "$PREV"`"
}

pet-select() {
    BUFFER=$(pet search)
    READLINE_LINE=$BUFFER
    READLINE_POINT=${#BUFFER}
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select
