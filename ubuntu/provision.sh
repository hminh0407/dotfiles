#!/usr/bin/env bash

# =====================================================================================================================
# LIBRARIES
# =====================================================================================================================

. $(dirname ${BASH_SOURCE[0]})/../scripts/base.sh
. $(dirname ${BASH_SOURCE[0]})/../b-log/b-log.sh

# =====================================================================================================================
# CONFIGURATION
# =====================================================================================================================

declare BAT_VERSION="0.6.1"
declare PET_VERSION="0.3.2"

LOG_LEVEL_ALL

# =====================================================================================================================
# UTIL FUNCTION
# =====================================================================================================================

echoServiceStatus() {
	local serviceName="${1}"
	local status="${2}"
	case ${status} in
		new)
			NOTICE "Installing ${serviceName}"
			;;
		installed)
			NOTICE "Already Installed ${serviceName}"
			;;
		*)
			ERROR "Usage: $0 {new|installed}"
			exit 1
	esac
}

# =====================================================================================================================
# FUNCTION
# =====================================================================================================================

ubuntu-provision () {
    # install apt-fast
    if isServiceExist apt-fast; then
		sudo add-apt-repository -y ppa:apt-fast/stable
		sudo add-apt-repository -y ppa:teni-ime/ibus-teni
		sudo apt-add-repository -y ppa:neovim-ppa/stable
		sudo add-apt-repository -y ppa:webupd8team/java
		sudo apt-get update -y
		sudo apt-get install -y --no-install-recommends apt-fast
    fi

    # install apt packages
    apt-fast install --no-install-recommends -y                                                         \
		snapd gnome-tweak-tool gnome-shell-extensions network-manager-l2tp-gnome ibus ibus-teni \
		zsh curl exuberant-ctags silversearcher-ag httpie rename ncdu wget xclip                \
		neovim tmux tig graphviz                                                                \
		direnv supervisor                                                                       \
		autossh docker-compose make                                                             \
		buku ca-certificates                                                                    \
		python-dev                                                                              \
		oracle-java8-set-default                                                                \
		npm                                                                                     \
		mpv nautilus-dropbox vifm

    # install snap packages
    snap install docker postman tldr
    # snap install communitheme clementine
    sudo apt autoremove # clear installation cache

    # install python packages
    sudo pip install mycli pgcli

    # setup ibus input
    ibus restart
    # to setup vietnamese keyboard follow instruction on
    # https://github.com/teni-ime/ibus-teni/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%E1%BA%A5u-h%C3%ACnh#1-keyboard-input-method-system-ibus
    # https://github.com/teni-ime/ibus-teni/wiki/H%C6%B0%E1%BB%9Bng-d%E1%BA%ABn-c%E1%BA%A5u-h%C3%ACnh#2-add-an-input-source-vietnameseteni
}

zsh-install () {
    if !isServiceExist zsh; then
		echoServiceStatus "ZSH" "new"

		local zshCustomPluginsPath="~/.oh-my-zsh/custom/plugins"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

		INFO "installing zsh autosuggestions..."
		gitClone git://github.com/zsh-users/zsh-autosuggestions.git ${zshCustomPluginsPath}/zsh-autosuggestions

		INFO "installing zsh highlighting..."
		gitClone git://github.com/zsh-users/zsh-syntax-highlighting.git ${zshCustomPluginsPath}/zsh-syntax-highlighting

		# reload current shell to use zsh
		env -i zsh
	else
		echoServiceStatus "ZSH" "installed"
	fi
}

bat-install () {
    if !isServiceExist bat; then
		echoServiceStatus "BAT" "new"

		wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb \
			-O /tmp/bat_${BAT_VERSION}_amd64.deb
		sudo dpkg -i /tmp/bat_${BAT_VERSION}_amd64.deb
    else
		echoServiceStatus "BAT" "installed"
    fi
}

java-config () {
    if !isServiceExist java; then
		NOTICE "JAVA - Setting up"

		# add java environment variable
		grep -qF 'JAVA_HOME' /etc/environment || \
			echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' | sudo tee --append /etc/environment
    fi
}

nvim-config () {
    if !isServiceExist nvim; then
		NOTICE "NVIM - Setting up"

		# use Neovim for some (or all) of the editor alternatives, use the following commands
		sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
		sudo update-alternatives --config vi
		sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
		sudo update-alternatives --config vim
		sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
		sudo update-alternatives --config editor

		# install tools used for plugins
		sudo npm install -g js-beautify # for Autoformat to format json and js file
	fi
}

pet-install () {
    if !isServiceExist pet; then
		echoServiceStatus "PET" "new"

		wget https://github.com/knqyf263/pet/releases/download/v${PET_VERSION}/pet_${PET_VERSION}_linux_amd64.deb \
			-O /tmp/pet_${PET_VERSION}_linux_amd64.deb
		sudo dpkg -i /tmp/pet_${PET_VERSION}_linux_amd64.deb

		# after copy config file, manual update config access_token
		yes | mkdir -p ~/.config/pet && cp -f ~/workspace/dotfiles/pet/config.toml ~/.config/pet/config.toml
	else
		echoServiceStatus "PET" "installed"
    fi
}

tmux-config () {
    if !isServiceExist tmux; then
		NOTICE "TMUX - Setting up"

		# install tmux plugin manager
		if cd ~/.tmux/plugins/tpm ; then
			git -C ~/.tmux/plugins/tpm pull;
		else
			git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		fi
		# install plugins
		~/.tmux/plugins/tpm/bin/install_plugins
		# install tmuxp & plugins
		# sudo -H pip3 install tmuxp
		sudo pip install tmuxp
		~/.tmux/plugins/tpm/scripts/install_plugins.sh
	fi
}

wine-install () {
    # enable x86 architecture support
    sudo dpkg --add-architecture i386
    # install wine
    wget -nc https://dl.winehq.org/wine-builds/Release.key
    sudo apt-key add Release.key
    sudo apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/
    sudo apt-get update && apt-fast install -y --install-recommends winehq-stable
}

# vim-install () {
#     # requre python and pip installed
#     # gui-vim should be installed instead of terminal vim because it support clipboard
#     if isServiceExist apt; then
#	sudo apt remove -y vim vim-runtime gvim # remove pre-installed vim

#	# build vim with latest version (with clipboard support)
#	# https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
#	if cd /tmp/vim ; then
#		git -C /tmp/vim pull;
#	else
#		git clone https://github.com/vim/vim.git /tmp/vim
#	fi
#	sudo apt build-dep vim
#	(
#		cd /tmp/vim                                                              && \
#		sudo make distclean                                                      && \
#		./configure --enable-multibyte                                              \
#			--enable-python3interp=yes                                      \
#			--enable-gui=gtk3                                               \
#			--with-x                                                        \
#			--enable-cscope                                                 \
#			--prefix=/usr/local                                             \
#                         # too many unessary features --with-features=huge                                            \
#		sudo make                                                                && \
#		sudo make install
#	)
#	# make vim the default application
#	sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
#	sudo update-alternatives --set editor /usr/local/bin/vim
#	sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
#	sudo update-alternatives --set vi /usr/local/bin/vim
#	sudo rm -r /tmp/vim

#     elif isServiceExist pacman; then
#         sudo pacman -S gvim ctags xclip --noconfirm --needed
#     fi

#     # install other tools for plugins
#     sudo pip3 install python-language-server ipdb jsbeautifier sqlparse

#     # setup config files
#     mkdir -p ~/.vim/after/ftplugin
#     ln -sfn ~/workspace/dotfiles/vim/ctags      ~/.ctags
#     ln -sfn ~/workspace/dotfiles/vim/vimrc      ~/.vimrc
#     ln -sfn ~/workspace/dotfiles/vim/vim-conf   ~/.vim-conf
#     ln -sfn ~/workspace/dotfiles/vim/ftplugin/* ~/.vim/after/ftplugin/

#     # install vim-anywhere, require gvim (or a derivative)
#     # https://github.com/cknadler/vim-anywhere
#     curl -fsSL https://raw.github.com/cknadler/vim-anywhere/master/install | bash
#     # to update: ~/.vim-anywhere/update
# }
# if isServiceExist vim; then
#     alias vim-update-plugin="vim +PlugUpdate +qall"
# fi

# =====================================================================================================================
# MAIN
# =====================================================================================================================

NOTICE "### Start Ubuntu Provisioning ###"

ubuntu-provision
zsh-install
java-config
nvim-config
pet-install
tmux-config
