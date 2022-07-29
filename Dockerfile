FROM ubuntu:focal

#RUN sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/' \
#	      /etc/apt/apt.conf.d/docker-clean

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV MAKEFLAGS="-j 16"


RUN apt update && \
    apt install autoconf automake build-essential cmake \
    git libass-dev libfreetype6-dev libsdl2-dev \
    libtheora-dev libtool libva-dev libvdpau-dev \
    libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev mercurial pkg-config \
    texinfo wget zlib1g-dev fontconfig \
    libvpx-dev libx264-dev libx265-dev libaom-dev \
    libmp3lame-dev libopus-dev \
    yasm nasm libxvidcore-dev libfribidi-dev libtheora-dev libfdk-aac-dev libgnutls28-dev -y && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf \
           /tmp/* \
           /var/cache/apt/archives/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

RUN apt update && apt install -y ocl-icd-opencl-dev;

WORKDIR /root

RUN git clone https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    ./configure --enable-pthreads --enable-gpl --enable-version3 --enable-nonfree --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom --enable-libass --enable-libfreetype --enable-libopus --enable-libxvid --enable-fontconfig --enable-libfontconfig --enable-libtheora --enable-libfribidi --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-swscale-alpha --enable-shared --enable-pic --enable-libfdk-aac --enable-gnutls --enable-opencl && \
    make && make install;

RUN git clone https://github.com/richardpl/lavfi-preview.git && \
    cd lavfi-preview

RUN apt install -y libdart-external-imgui-dev libglfw3-dev libopenal-dev;

# don't need the whole xorg, just: pkg-config glfw3 --print-requires-private
# x11
# xrandr
# xinerama
# xxf86vm
# xcursor 

RUN apt install -y xorg

#RUN version="3.2.1" && \
#    apt-get install -y unzip cmake xorg-dev libglu1-mesa-dev && \
#    wget "https://github.com/glfw/glfw/releases/download/${version}/glfw-${version}.zip" && \
#    unzip glfw-${version}.zip && \
#    cd glfw-${version} && \
#    cmake -G "Unix Makefiles" && \
#    make && \
#    make install

WORKDIR /root/lavfi-preview

COPY ./Makefile ./Makefile

RUN make

ENTRYPOINT /root/lavfi-preview/lavfi-preview 
