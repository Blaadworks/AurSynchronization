FROM archlinux:latest

RUN pacman -Sy --noconfirm base-devel openssh git curl jq


RUN useradd -ms /bin/bash synchronizer && echo 'synchronizer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=synchronizer:synchronizer entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER synchronizer
WORKDIR /home/synchronizer

ENTRYPOINT ["/entrypoint.sh"]
