main() {

  # Define custom scripts
  declare FZF="$(dirname ${(%):-%N})/fzf.zsh"
  declare PET="$(dirname ${(%):-%N})/pet.zsh"
  declare INTEGRATION="$(dirname ${(%):-%N})/integration.zsh"

  declare SCRIPTS=($FZF $PET $INTEGRATION)

  # Load custom scripts
  for script in "$SCRIPTS[@]"; do [ -f $script ] && source $script; done
}

main
