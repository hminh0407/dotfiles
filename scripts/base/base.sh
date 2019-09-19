# Store all base functions

appendToFileIfNotExist () {
    [ -z "$1" ] && { echo  "missed param 'line'"; exit 1; }
    [ -z "$2" ] && { echo  "missed param 'file'"; exit 1; }

    local line="$1"
    local file="$2"
    grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

isServiceExist () {
    # https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
    local service="${1}"
    [ -x "$(command -v $service)" ]
}

# clone git if not exist, pull latest code if exist
gitClone () {
    [ -z "$1" ] && { echo "missed param 'repo'"; exit 1; }
    [ -z "$2" ] && { echo "missed param 'localRepo'"; exit 1; }
    local repo="${1}"
    local localRepo="${2}"

    # git clone ${repo} ${localRepo} 2> /dev/null || git -C ${localRepo} pull
    git -C ${localRepo} pull || git clone --depth=1 --recursive ${repo} ${localRepo}
}
