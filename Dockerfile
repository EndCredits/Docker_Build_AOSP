FROM debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Force apt ipv4
RUN echo 'Acquire::ForceIPv4 "True";' > /etc/apt/apt.conf.d/99-force-ipv4

RUN apt-get update \
    && apt-get install -y bc bison build-essential ccache curl flex fontconfig \
                          gcc-multilib git g++-multilib gnupg gperf imagemagick \
                          lib32ncurses5-dev lib32readline-dev lib32z1-dev libc6-dev-i386 \
                          libgl1-mesa-dev liblz4-tool libncurses5 libncurses5-dev \
                          libx11-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils \
                          unzip x11proto-core-dev lzop pngcrush python3-sepolgen rsync \
                          schedtool squashfs-tools xsltproc zip zlib1g-dev cpio vim \
                          dos2unix fish locales sudo patchelf git-lfs libelf-dev elfutils \
                          dwarves

RUN echo "${username} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -o /usr/local/bin/repo https://mirrors.tuna.tsinghua.edu.cn/git/git-repo \
    && chmod a+x /usr/local/bin/repo

RUN dpkg-reconfigure locales \
    && locale-gen C.UTF-8 \
    && /usr/sbin/update-locale LANG=C.UTF-8

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen

RUN groupadd -o -g $groupid $username \
    && useradd -m -u $userid -g $groupid $username \
    && echo $username >/root/username \
    && echo "export USER="$username >>/home/$username/.gitconfig

COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig
ENV HOME=/home/$username
ENV USER=$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /usr/bin/fish -i
