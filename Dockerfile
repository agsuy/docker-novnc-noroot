FROM debian:stretch

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      bash \
      fluxbox \
      git \
      net-tools \
      novnc \
      socat \
      sudo \
      supervisor \
      x11vnc \
      xterm \
      xvfb

RUN adduser --disabled-password --gecos '' novnc
RUN adduser novnc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/novnc/logs
RUN mkdir -p /home/novnc/pid
RUN chown -R novnc:novnc /home/

# Setup demo environment variables
ENV HOME=/home/novnc \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

COPY . /app
EXPOSE 8080

USER novnc:novnc

WORKDIR /home/novnc
