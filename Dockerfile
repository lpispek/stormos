FROM ubuntu:24.04

LABEL maintainer="general@stormos.hr"
LABEL description="⚡ StormOS 1.0 Bura — Prva hrvatska Linux distribucija"
LABEL version="1.0-bura"

# Suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV LANG=hr_HR.UTF-8
ENV LC_ALL=hr_HR.UTF-8

# Install essentials
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    wget \
    git \
    neofetch \
    figlet \
    toilet \
    locales \
    nano \
    htop \
    tree \
    bat \
    man-db \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set up Croatian locale
RUN sed -i '/hr_HR.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# ============================================
# StormOS user & directories
# ============================================
RUN useradd -m -s /bin/bash -G sudo general && \
    echo "general:oluja1995" | chpasswd

# ============================================
# oluja — package manager wrapper
# ============================================
COPY scripts/oluja.sh /usr/local/bin/oluja
RUN chmod +x /usr/local/bin/oluja

# ============================================
# general — sudo wrapper
# ============================================
COPY scripts/general.sh /usr/local/bin/general
RUN chmod +x /usr/local/bin/general

# ============================================
# ako-ne-znaš-šta-je-bilo — history wrapper
# ============================================
COPY scripts/ako-ne-znas-sta-je-bilo.sh /usr/local/bin/ako-ne-znas-sta-je-bilo
RUN chmod +x /usr/local/bin/ako-ne-znas-sta-je-bilo

# ============================================
# oj — wall wrapper (broadcast message)
# ============================================
COPY scripts/oj.sh /usr/local/bin/oj
RUN chmod +x /usr/local/bin/oj

# ============================================
# Custom neofetch config + ASCII art
# ============================================
RUN mkdir -p /home/general/.config/neofetch
COPY config/neofetch.conf /home/general/.config/neofetch/config.conf
COPY config/stormos-ascii.txt /usr/share/stormos/ascii.txt

# ============================================
# Custom MOTD (Message of the Day)
# ============================================
RUN rm -rf /etc/update-motd.d/*
COPY docker/motd.sh /etc/update-motd.d/00-stormos
RUN chmod 755 /etc/update-motd.d/00-stormos

# ============================================
# Custom .bashrc for StormOS experience
# ============================================
COPY docker/bashrc /home/general/.bashrc

# ============================================
# StormOS error messages & aliases config
# ============================================
COPY docker/stormos-aliases.sh /etc/profile.d/stormos-aliases.sh
RUN chmod 755 /etc/profile.d/stormos-aliases.sh

# ============================================
# Croatian 404 & error handler
# ============================================
COPY docker/command-not-found.sh /etc/profile.d/command-not-found.sh
RUN chmod 755 /etc/profile.d/command-not-found.sh

# ============================================
# Fake /etc/os-release
# ============================================
RUN echo 'PRETTY_NAME="StormOS 1.0 Bura"' > /etc/os-release && \
    echo 'NAME="StormOS"' >> /etc/os-release && \
    echo 'VERSION_ID="1.0"' >> /etc/os-release && \
    echo 'VERSION="1.0 (Bura)"' >> /etc/os-release && \
    echo 'VERSION_CODENAME=bura' >> /etc/os-release && \
    echo 'ID=stormos' >> /etc/os-release && \
    echo 'ID_LIKE=ubuntu' >> /etc/os-release && \
    echo 'HOME_URL="https://stormos.pages.dev"' >> /etc/os-release && \
    echo 'SUPPORT_URL="https://github.com/AdriaticSolutions/stormos/issues"' >> /etc/os-release && \
    echo 'BUG_REPORT_URL="https://github.com/AdriaticSolutions/stormos/issues"' >> /etc/os-release

# ============================================
# Fake package stubs (for fun)
# ============================================
RUN mkdir -p /usr/share/stormos && \
    echo "bašćanka 4.2.0-hr1 — Uređivač teksta inspiriran Bašćanskom pločom" > /usr/share/stormos/packages.list && \
    echo "škrinja 2.1.0-hr1 — Upravitelj datoteka. Otvorite škrinju, pronađite blago." >> /usr/share/stormos/packages.list && \
    echo "tesla 3.0.0-hr1 — Monitor sustava. Hrvatski izum." >> /usr/share/stormos/packages.list && \
    echo "moreška 1.5.0-hr1 — Vatrozid. Dva su se cara prepirala." >> /usr/share/stormos/packages.list && \
    echo "gusle 1.2.0-hr1 — Glazbeni player. Equalizer za tamburicu." >> /usr/share/stormos/packages.list && \
    echo "ruža 1.0.0-hr1 — Preglednik slika. Auto-enhance za Jadran." >> /usr/share/stormos/packages.list

# Fix ownership
RUN chown -R general:general /home/general

# Switch to general user
USER general
WORKDIR /home/general

# Default command — login shell to trigger MOTD
CMD ["/bin/bash", "--login"]
