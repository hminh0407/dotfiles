#!/usr/bin/env bash

install () {
    # Install packages to allow apt to use a repository over HTTPS
    apt-fast install --no-install-recommends -y \
        apt-transport-https                     \
        ca-certificates                         \
        curl                                    \
        gnupg-agent                             \
        software-properties-common

    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
    sudo apt-key fingerprint 0EBFCD88

    # Use the following command to set up the stable repository
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    # update apt package index
    sudo apt-get update

    # install latest version of Docker CE
    sudo apt-fast install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose

    # add docker group
    sudo groupadd docker

    # add current user to docker group
    sudo gpasswd -a $USER docker
}

install
