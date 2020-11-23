# Dev Environment

## Note

*Support Ubuntu only*

Use [dotbot](https://github.com/anishathalye/dotbot) dotfiles manager to manage dotfiles environment
---

## Require

* Git

## Test with Docker
There's a docker setup to try out the tools and config.
* run `docker-compose up -d ubuntu` to start the container
* run `docker exec -it dotfiles_ubuntu_1 bash` to start a new shell in container
* then you can try to run the install script and play with the config

## Install

Install with profile (install group of modules together: check meta/profiles for supported profile)
`./install-profile <profile> [<configs...>]` `Ex: ./install-profile terminal`

Install single package (install 1 module at a time: check meta/configs for supported package)
`./install-standalone <configs...>` `Ex: ./install-profile nvim`

## Modules

### ZSH

#### Environment Variables

Environment variables will be scripted and combined in `zsh/zshrc.d/04-integration.zsh`
To add custom environment variables create zsh that defines environment variables in `$HOME/.scripts/custom`
