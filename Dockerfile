# this container is to test the environment setup on ubuntu
FROM ubuntu:20.04

# make apt installation non interactive
ENV DEBIAN_FRONTEND=noninteractive

# install required tools
RUN apt-get update -y && apt-get --no-install-recommends --fix-missing -y install sudo software-properties-common python3 python3-pip git

# alias pip with pip3
RUN ln -sfn /bin/pip3 /bin/pip

# this keep the container running
CMD tail -f /var/log/bootstrap.log
