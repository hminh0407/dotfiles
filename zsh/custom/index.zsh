# Define custom scripts
FZF="$(dirname ${(%):-%N})/fzf.zsh"
PET="$(dirname ${(%):-%N})/pet.zsh"
INTEGRATION="$(dirname ${(%):-%N})/integration.zsh"

SCRIPTS=($FZF $PET $INTEGRATION)

# Load custom scripts
for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done
