# this container is to test the environment setup on ubuntu
FROM ubuntu:18.04

# install required tools
RUN apt-get update && apt-get install --no-install-recommends -y curl software-properties-common
# install apt-fast
RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y apt-fast
# install other tools
RUN apt-fast install --no-install-recommends -y sudo git python python-setuptools

WORKDIR /dotfiles

# this keep the container running
CMD tail -f /var/log/bootstrap.log
