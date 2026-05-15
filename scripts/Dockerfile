FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install -y \
    pkg-config build-essential ninja-build automake autoconf libtool \
    wget curl git gcc libssl-dev bc slib squashfs-tools \
    android-sdk-libsparse-utils rsync jq cmake python3-distutils \
    tclsh scons parallel ssh-client tree python3-dev python3-pip \
    device-tree-compiler ssh cpio fakeroot libncurses5-dev flex bison \
    android-libext4-utils bdebstrap proot fakechroot bzr ca-certificates \
    cvs file locales mercurial python3 python-is-python3 python3-flake8 python3-nose2 \
    python3-pexpect subversion unzip ccache gawk diffstat texinfo \
    chrpath socat iputils-ping python3-git python3-jinja2 python3-subunit \
    zstd liblz4-tool libacl1 parted erofs-utils genext2fs mtools fatcat \
    ckermit neovim cscope asciinema libconfuse-dev dosfstools gettext \
    autoconf-archive clang u-boot-tools libgmp-dev libmpc-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US.UTF-8  
ENV LC_ALL=en_US.UTF-8

ARG USER_NAME=developer
ARG USER_ID=1000
ARG GROUP_NAME=developer
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -l -u ${USER_ID} -g ${GROUP_ID} -d /home/${USER_NAME} -s /bin/bash ${USER_NAME}

USER ${USER_NAME}

