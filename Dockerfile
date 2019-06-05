FROM debian:stretch

# Install git, supervisor, VNC, X11 as well as ca, https and gnupg2 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      bash \
      ca-certificates \
      curl \
      fluxbox \
      git-core \
      gnupg2 \
      net-tools \
      novnc \
      libssl-dev \
      openssl \
      socat \
      sudo \
      supervisor \
      wget \
      x11vnc \
      xloadimage \
      xterm \
      xvfb && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Install chrome-stable

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Set enviroment

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080

# Create no-root user

RUN adduser --disabled-password --gecos '' novnc
RUN adduser novnc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/novnc/logs /home/novnc/pid && chown -R novnc:novnc /home/ 

# Install NodeJS 12 as root

ENV HOME=/home/novnc
ENV npm_config_loglevel warn
ENV npm_config_unsafe_perm true

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
# Set session

USER novnc:novnc
WORKDIR /home/novnc

# Copy supervisord config

COPY . /app
EXPOSE 8080

