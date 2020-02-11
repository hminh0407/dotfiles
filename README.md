# Note

*Support Ubuntu only*

Use [dotbot](https://github.com/anishathalye/dotbot) dotfiles manager to manage dotfiles environment
---

# Require

* Git

# Usage

It is recommend to fork this project

## Docker
There's a docker setup to try out the tools and config.
* run `docker-compose up -d ubuntu` to start the container
* run `docker exec -it dotfiles_ubuntu_1 /bin/sh` to start a new shell in container
* then you can try to run the install script and play with the config

## Install Module

`./install-profile default` should be run (to make sure that script files are granted the proper permission to run)
* before the first installation
* and everytime a new install script is added

Install with profile (install group of modules together: check meta/profiles for supported profile)
`./install-profile <profile> [<configs...>]` `Ex: ./install-profile terminal`

Install single package (install 1 module at a time: check meta/configs for supported package)
`./install-standalone <configs...>` `Ex: ./install-profile nvim`

## Custom script & binary

* Custom sh files will be automatically available if placed in `~/.project/` (need restart)
* Custom binary files will be automatically available if placed in `~/bin`
