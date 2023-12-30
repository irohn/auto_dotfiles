FROM ubuntu:22.04

RUN apt update && apt install -y \
    jq \
    git \
    curl \
    sudo

RUN useradd -m -s /bin/bash -G sudo ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu

WORKDIR /home/ubuntu

CMD ["/bin/bash"]