# Store all package that need to be integrated with shell

# Define modules to integrate with
NTFY="$(ntfy shell-integration)"

MSSQL_TOOLS="/opt/mssql-tools/bin"

EXPORT_PATH="${PATH}"

SOURCE_MODULES=()
PATH_MODULES=($CUSTOM_SCRIPTS $MSSQL_TOOLS)

# Load integration modules
for module in "$SOURCE_MODULES[@]"; do [ -f $module ] && source $module; done
for module in "$PATH_MODULES[@]"; do
    if [ -d "$module" ] && [[ ":$EXPORT_PATH:" != *":$module:"* ]]; then
        EXPORT_PATH="${EXPORT_PATH:+"$EXPORT_PATH:"}$module"
    fi
done
export PATH=$EXPORT_PATH

# eval modules need to be checked carefully
_is_service_exist ntfy && eval $NTFY

