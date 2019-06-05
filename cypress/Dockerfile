FROM agsqa/novnc-rootless-chrome:beta

RUN sudo apt-get update && \
sudo apt-get install -y --no-install-recommends \
  libgtk2.0-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 && sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN mkdir ~/npm-global && npm config set prefix '~/.npm-global' && export PATH=~/.npm-global/bin:$PATH

RUN npm install -g npm
RUN sudo apt-get update && \
  sudo apt-get install -y --no-install-recommends yarn

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n"
