#!/usr/bin/env bash

install () {
    apt-fast install --no-install-recommends -y ffmpeg

    local location="$DOTFILES_BIN_DIR/youtube-dl"
    local link="https://yt-dl.org/downloads/latest/youtube-dl"

    wget -qO $location $link && chmod +x $location
}

install
