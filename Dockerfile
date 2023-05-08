FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig

RUN apt-get update && apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev

RUN apt-get -y install sudo \
    && echo "${username} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get update && apt-get -y install python2 cpio

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -o /usr/local/bin/repo https://mirrors.tuna.tsinghua.edu.cn/git/git-repo \
 && chmod a+x /usr/local/bin/repo

RUN apt-get -y install vim dos2unix

RUN groupadd -o -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username \
 && echo "export USER="$username >>/home/$username/.gitconfig

COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig
ENV HOME=/home/$username
ENV USER=$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
