#!/usr/bin/env bash

removeGitSubModule () {
	if [ $# -ne 1 ]; then
			echo "Usage: $0 <submodule full name>"
			exit 1
	fi

	submodule="$1"
	module_name_for_sed=$(echo $submodule | sed -e 's/\//\\\//g')

	# remove from .gitmodules
	cat .gitmodules | sed -ne "/^\[submodule \"$module_name_for_sed\"/,/^\[submodule/!p" > .gitmodules.tmp
	sudo mv .gitmodules.tmp .gitmodules
	git add .gitmodules
	cat .git/config | sed -ne "/^\[submodule \"$module_name_for_sed\"/,/^\[submodule/!p" > .git/config.tmp
	sudo mv .git/config.tmp .git/config

	# remove all related files
	git rm --cached "$submodule"
	sudo rm -rf ".git/modules/$submodule"
	sudo rm -rf $submodule

	git config -f ".git/config" --remove-section "submodule.$submodule" 2> /dev/null
}

