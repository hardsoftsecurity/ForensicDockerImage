FROM ubuntu:22.04

# Set environment variables to suppress prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install basic dependencies, including tzdata
RUN apt update && apt install -y \
    software-properties-common \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    unzip \
    openjdk-11-jre \
    net-tools \
    tzdata \
    sudo \
    libsecret-1-0 \
    dbus-x11 \
    libx11-xcb1 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    xdg-utils \
    --no-install-recommends \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Install Wireshark
RUN apt update && apt install -y wireshark && apt clean && rm -rf /var/lib/apt/lists/*

# Install Zeek
RUN wget -q -O - https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | apt-key add - \
    && echo "deb https://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /" > /etc/apt/sources.list.d/zeek.list \
    && apt update && apt install -y zeek && apt clean && rm -rf /var/lib/apt/lists/*

# Install Suricata
RUN apt update && apt install -y suricata && apt clean && rm -rf /var/lib/apt/lists/*

# Install nfdump and nfpcapd
RUN apt update && apt install -y nfdump && apt clean && rm -rf /var/lib/apt/lists/*

# Install RITA
RUN curl -s https://github.com/activecm/rita/releases/download/v5.0.8/install-rita-zeek-here.sh | bash

# Install NetworkMiner
RUN sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
    && sudo apt update && sudo apt install mono-devel -y && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/networkminer \
    && wget -q https://www.netresec.com/?download=NetworkMiner -O /tmp/networkminer.zip \
    && unzip /tmp/networkminer.zip -d /opt/networkminer \
    && rm /tmp/networkminer.zip

# Fix for Zui (Brim)
RUN wget -q https://github.com/brimdata/zui/releases/download/v1.18.0/zui_1.18.0_amd64.deb -O /tmp/zui.deb \
    && dpkg -i /tmp/zui.deb \
    && rm /tmp/zui.deb

# Expose the port used by Zui's lake
EXPOSE 9867

# Install Volatility
RUN wget -q https://github.com/volatilityfoundation/volatility/releases/download/2.6.1/volatility_2.6_lin64_standalone.zip -O /tmp/volatility.zip \
    && unzip /tmp/volatility.zip -d /opt/volatility \
    && rm /tmp/volatility.zip

# Set up a non-root user for analysis
ARG USER=analyst
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $USER \
    && useradd -m -u $UID -g $GID -s /bin/bash $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/$USER
USER $USER

# Default command
CMD ["/bin/bash"]
