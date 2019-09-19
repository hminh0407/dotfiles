# Note

*Support Ubuntu only*

Use [dotbot](https://github.com/anishathalye/dotbot) dotfiles manager to manage dotfiles environment
---

# Require

* Git

# Usage

Install with profile (check meta/profiles for supported profile)
`./install-profile <profile> [<configs...>]` `Ex: ./install-profile terminal`

Install single package (check meta/configs for supported package)
`./install-standalone <configs...>` `Ex: ./install-profile nvim`
Note that for any new configuration with sh file scripts installation, command
`./install-profile default` must be run to set up execution permission for script files
