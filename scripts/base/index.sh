# Define custom scripts
LOG="$(dirname ${BASH_SOURCE[0]})/log.sh"
BASE="$(dirname ${BASH_SOURCE[0]})/base.sh"
ENV="$(dirname ${BASH_SOURCE[0]})/env.sh"
INTEGRATION="$(dirname ${BASH_SOURCE[0]})/integration.sh"

# aliases
ALIASES="$(dirname ${BASH_SOURCE[0]})/aliases.sh"
GCLOUD_ALIASES="$(dirname ${BASH_SOURCE[0]})/gcloud_aliases.sh"

SCRIPTS=($LOG $BASE $ENV $INTEGRATION $ALIASES $GCLOUD_ALIASES)

# Load custom scripts
for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done

