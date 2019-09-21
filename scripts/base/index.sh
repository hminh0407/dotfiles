# Define custom scripts
readonly ALIASES="$(dirname ${BASH_SOURCE[0]})/aliases.sh"
readonly ENV="$(dirname ${BASH_SOURCE[0]})/env.sh"
readonly FUNTIONS="$(dirname ${BASH_SOURCE[0]})/functions.sh"
readonly INTEGRATION="$(dirname ${BASH_SOURCE[0]})/integration.sh"
readonly LOG="$(dirname ${BASH_SOURCE[0]})/log.sh"

# script order matter
readonly SCRIPTS=($ENV $FUNTIONS $ALIASES $INTEGRATION $LOG)

# Load custom scripts
for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done

