FROM ubuntu:16.04
MAINTAINER MENTAL

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y \
        --no-install-recommends \
        acl \
        apt-transport-https \
        bridge-utils \ 
        ca-certificates \
        cpio \
        curl \
        gettext \
        libcanberra-gtk-module \
        libcurl3-gnutls \
        libsdl1.2debian \
        libwebkitgtk-1.0-0 \
        libv4l-0 \
        libvirt-bin \
        libxcb-render-util0 \
        libxcb-randr0 \
        libxcb-shape0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxtst6 \
        make \
        openvpn \
        pciutils \
        python2.7 \
        qemu-kvm \
        rpm2cpio \
        sudo \
        zenity \
        zip

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y \
        --no-install-recommends \
        yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/jellyfin-tizen-builder
COPY dependencies.sh /opt/jellyfin-tizen-builder
CMD ["/opt/jellyfin-tizen-builder/dependencies.sh"]
RUN ls /opt/jellyfin-tizen-builder

RUN useradd -m -G sudo,kvm,libvirtd tizen && \
    passwd -d tizen
USER tizen

WORKDIR /opt/jellyfin-tizen-builder
ENV BASH_ENV /opt/jellyfin-tizen-builder/.profile
SHELL ["/bin/bash", "-c"]

RUN tar zxf jdk-8u172-linux-x64.tar.gz -C ~/ && \
    echo 'export JAVA_HOME=$HOME/jdk1.8.0_172' >> ~/.profile && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.profile && \
    rm jdk-8u172-linux-x64.tar.gz

RUN ./web-cli_Tizen_Studio_2.4_ubuntu-64.bin \
    --accept-license \
    ~/tizen-studio && \
    echo 'export PATH=$PATH:$HOME/tizen-studio/tools' >> ~/.profile && \
    rm web-cli_Tizen_Studio_2.4_ubuntu-64.bin
    
CMD ["/bin/bash", "--login"]
