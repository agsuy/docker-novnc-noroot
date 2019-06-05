FROM debian:stretch

# Install git, supervisor, VNC, X11 as well as ca, https and gnupg2 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      bash \
      ca-certificates \
      fluxbox \
      git \
      gnupg2 \
      net-tools \
      novnc \
      socat \
      sudo \
      supervisor \
      x11vnc \
      xterm \
      xvfb && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Install chrome-stable
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Create no-root user
RUN adduser --disabled-password --gecos '' novnc
RUN adduser novnc sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/novnc/logs /home/novnc/pid && chown -R novnc:novnc /home/

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

# Set session
USER novnc:novnc
WORKDIR /home/novnc
