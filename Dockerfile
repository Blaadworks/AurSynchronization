FROM archlinux:latest

RUN pacman -Syu --noconfirm base-devel openssh git curl jq && \
    pacman -Scc --noconfirm

RUN useradd -ms /bin/bash synchronizer && \
    echo 'synchronizer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER synchronizer
WORKDIR /home/synchronizer

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
