#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE[0]})/../base/functions.sh

install () {
    sudo add-apt-repository -y ppa:webupd8team/java
    apt-fast install --no-install-recommends -y oracle-java8-set-default                                                                \

    # add java environment variable
    grep -qF 'JAVA_HOME' /etc/environment || \
        echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' | sudo tee --append /etc/environment
}

install
