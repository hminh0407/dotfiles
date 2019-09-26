#!/usr/bin/env bash

set -e

DEFAULT_CONFIG="default"
BASE_CONFIG="base"
CONFIG_SUFFIX=".yml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASE_DIR}"
git -C "${META_DIR}/${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive

while IFS= read -r config; do
	CONFIGS+=" ${config}"
done < "${META_DIR}/${PROFILES_DIR}/$1"

shift

echo ${CONFIGS}

# a default profile will always be checked to make sure that all the essential packages are installed.
for config in ${DEFAULT_CONFIG} ${CONFIGS}; do
	echo -e "\nConfigure $config"
	configFile="$(mktemp)" ; echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}")" > "$configFile"
	"${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile" ; rm -f "$configFile"
done
