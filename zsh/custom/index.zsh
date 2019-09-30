# Define custom scripts
KEYBIND="$(dirname ${(%):-%N})/keybind.zsh"
INTEGRATION="$(dirname ${(%):-%N})/integration.zsh"

SCRIPTS=($KEYBIND $INTEGRATION)

# Load custom scripts
for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done
