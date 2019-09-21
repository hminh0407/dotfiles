# Define custom scripts
ALIASES="$(dirname ${BASH_SOURCE[0]})/aliases.sh"
ENV="$(dirname ${BASH_SOURCE[0]})/env.sh"
FUNTIONS="$(dirname ${BASH_SOURCE[0]})/functions.sh"
INTEGRATION="$(dirname ${BASH_SOURCE[0]})/integration.sh"
LOG="$(dirname ${BASH_SOURCE[0]})/log.sh"

# script order matter
SCRIPTS=($ENV $FUNTIONS $ALIASES $INTEGRATION $LOG)

# Load custom scripts
for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done

