#!/usr/bin/env bash

# =============================================================================
# internal util functions
# =============================================================================

_opts_external() {
    grep "^[a-zA-Z]\w*() {" "$0" | grep -oP '\w+'
        # grep with specific group match, check https://unix.stackexchange.com/a/13472
}

_opts() {
    grep "^\w*() {" "$0" | grep -oP '\w+'
        # grep with specific group match, check https://unix.stackexchange.com/a/13472
}

_join_by() {
    local delimiter="$1" # Save first argument in a variable
    shift            	 # Shift all arguments to the left (original $1 gets lost)
    local items=("$@")   # Rebuild the array with rest of arguments

    local IFS=$delimiter; echo "${items[*]}";
}

_element_in_array() {
    local element="$1"
    shift
    local array=("$@")

    [[ "$element" == @($(_join_by '|' "${array[@]//|/\\|}")) ]]
}

# =============================================================================
# supported functions
# =============================================================================

compute_address() {
    gcloud compute addresses list "$@"
}

compute_address_reserved_internal() {
    gcloud gcp compute addresses list --filter='status=RESERVED AND addressType=EXTERNAL'
}

compute_disk() {
    local fields=(
        'name'
        'sizeGb'
        'type.basename()'
        'status'
        'labels.list()'
        'users.basename().list()'
    )
    local format_str="table($(_join_by ',' ${fields[@]}))"
    gcloud compute disks list --format="$format_str"
}

compute_disk_add_label() {
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    [ -z "$2" ] && { echo  "missing argument"; exit 1; }
    [ -z "$3" ] && { echo  "missing argument"; exit 1; }

    local pattern="$1"
    local label_key="$2"
    local label_value="$3"

    for instance in $( gcloud compute disks list --uri --filter="name~'.*$pattern.*'" ); do
        gcloud compute disks add-labels --labels="$label_key=$label_value" $instance
    done
}

compute_disk_find_unused() {
    gcloud compute disks list --format json \
        | fx '.filter(item => !item.users ).map( item => { return { id: item.id, name: item.name, last_attach: item.lastAttachTimestamp, last_dettach: item.lastDetachTimestamp, users: item.users } })' \
        | json2csv --quote '' \
        | csvformat -D ' '
}

compute_disk_delete_unused() {
    compute_disk_find_unused \
        | tail -n +2 \
        | awk '{print $2}' \
        | xargs -r gcloud compute disks delete
}

compute_disk_remove_policy_attachment() {
    [ -z "$1" ] && { echo  "need to provide disk name pattern"; exit 1; }
    [ -z "$2" ] && { echo  "need to provide policy name"; exit 1; }

    local pattern="$1"
    local policy="$2"

    for disk in $( gcloud compute disks list --uri --filter="name~'.*$pattern.*'" ); do
        gcloud compute disks remove-resource-policies $disk --resource-policies=$policy
    done
}

compute_disk_without_label() {
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    local label="$1"
    gcloud compute disks list --filter="-labels.${label}:*" --format="value(name)"
}

compute_scp() {
    gcloud compute scp --internal-ip
}

compute_ssh() {
    gcloud compute ssh --internal-ip
}

compute_snapshot() {
    local fields=(
        'name'
        'diskSizeGb'
        'sourceDisk.basename()'
        'status'
        'labels.list()'
        'creationTimestamp'
    )
    local format_str="table($(_join_by ',' ${fields[@]}))"
    gcloud compute snapshots list --format="$format_str"
}

compute_snapshot_add_label() {
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    [ -z "$2" ] && { echo  "missing argument"; exit 1; }
    [ -z "$3" ] && { echo  "missing argument"; exit 1; }

    local pattern="$1"
    local label_key="$2"
    local label_value="$3"

    for instance in $( gcloud compute snapshots list --uri --filter="name~'.*$pattern.*'" ); do
        gcloud compute snapshots add-labels --labels="$label_key=$label_value" $instance
    done
}

compute_vm() {
    local fields=(
        'name'
        'zone.basename()'
        'machineType.basename()'
        'scheduling.preemptible.yesno(yes=true, no='')'
        'networkInterfaces[0].networkIP:label=INTERNAL_IP'
        'networkInterfaces[0].accessConfigs[0].natIP:label=EXTERNAL_IP'
        'status'
        'labels.list()'
        'disks[0].licenses.list()'
    )
    local format_str="table($(_join_by ',' ${fields[@]}))"
    gcloud compute instances list --format="$format_str"
}

compute_vm_add_label() {
    # add label to multiple instance that have the same pattern
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    [ -z "$2" ] && { echo  "missing argument"; exit 1; }
    [ -z "$3" ] && { echo  "missing argument"; exit 1; }

    local pattern="$1"
    local label_key="$2"
    local label_value="$3"

    for instance in $( gcloud compute instances list --uri --filter="name~'.*$pattern.*'" ); do
        gcloud compute instances add-labels --labels="$label_key=$label_value" $instance
    done
}

compute_vm_with_label() {
    # return list of all instances that have a specific label
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    local label="$1"
    gcloud compute instances list --filter="labels.${label}:*" --format="value(name)"
}

compute_vm_without_label() {
    # return list of all instances that do not have a specific label
    [ -z "$1" ] && { echo  "missing argument"; exit 1; }
    local label="$1"
    gcloud compute instances list --filter="-labels.${label}:*" --format="value(name)"
}

config_project() {
    gcloud config get-value project -q
}

container_cluster() {
    gcloud container clusters list "$@"
}

service() {
    gcloud services list \
        --format='table(config.name,config.title,config.documentation.summary)'
}

sql() {
    # list of gcloud compute instances and describe selected instance if possible
    local fields=(
        'name'
        'databaseVersion'
        'gceZone'
        'settings.tier'
        'ipAddresses[0].ipAddress:label=PRIMARY_IP'
        'ipAddresses[1].ipAddress:label=NAT_IP'
        'ipAddresses[2].ipAddress:label=INTERNAL_IP'
        'settings.userLabels.list()'
        'state'
    )
    local format_str="table($(_join_by ',' ${fields[@]}))"

    gcloud sql instances list --format="$format_str"
}

# =============================================================================
# main
# =============================================================================

_main() {
    # wrapper for gcp with additional custom functions
    local opt="${1:-'unsupported'}"
    local opts=( $(_opts) )

    local array1=('one' two 'three|four' 'five six')

    if _element_in_array "$opt" "${opts[@]}"; then
        # https://superuser.com/a/316690
        "$@"
    else
        gcloud "$@"
    fi
}

_main "$@"
