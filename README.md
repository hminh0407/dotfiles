## Note

*Support Ubuntu only*

Use [dotbot](https://github.com/anishathalye/dotbot) dotfiles manager to manage dotfiles environment
---

## Usage

Install with profile (check meta/profiles for supported profile)
`./install-profile <profile> [<configs...>]`
`Ex: ./install-profile dev`

Install single configuration (check meta/configs for supported configurations)
`./install-standalone <configs...>`
`Ex: ./install-profile nvim`

---

## Core Packages
* shell environment        : zsh & oh-my-zsh
* terminal multiplexer     : tmux
* text editor              : nvim
* isolated dev environment : direnv
* process mangement        : supervisor
* container environment    : docker & docker-compose
* vietnamese input         : ibus & ibus-teni
* java                     : oracle-java-8
* bookmark manager         : buku
