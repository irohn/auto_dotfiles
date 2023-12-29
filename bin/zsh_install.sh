#!/bin/bash

OPERATING_SYSTEM=$(uname -o | tr '[:upper:]' '[:lower:]' || echo "unknown")
LINUX_DISTRO=$(awk -F'=' '/^ID=/ { gsub("\"","",$2); print tolower($2) }' /etc/*-release 2> /dev/null || echo "unknown")

# Check if zsh already installed
if [ -x "$(command -v zsh)" ]; then
    echo "zsh already installed"
    SKIP_ZSH_INSTALL="true"
fi

if [ "$SKIP_ZSH_INSTALL" != "true" ]; then
    if [ "$OPERATING_SYSTEM" == "gnu/linux" ]; then
        if [ "$LINUX_DISTRO" == "ubuntu" ]; then
            sudo apt-get install -y zsh
        elif [ "$LINUX_DISTRO" == "arch" ]; then
            sudo pacman -S --noconfirm zsh
        elif [ "$LINUX_DISTRO" == "centos" ]; then
            sudo yum install -y zsh
        elif [ "$LINUX_DISTRO" == "fedora" ]; then
            sudo dnf install -y zsh
        elif [ "$LINUX_DISTRO" == "rhel" ]; then
            sudo yum install -y zsh
        elif [ "$LINUX_DISTRO" == "debian" ]; then
            sudo apt-get install -y zsh
        elif [ "$LINUX_DISTRO" == "alpine" ]; then
            sudo apk add zsh
        else
            echo "Unknown Linux distribution"
            exit 1
        fi
    elif [ "$OPERATING_SYSTEM" == "darwin" ]; then
        brew install zsh
    else
        echo "Unknown operating system"
        exit 1
    fi
fi

# Check if oh-my-zsh already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh already installed"
    SKIP_OMZ_INSTALL="true"
fi

if [ "$SKIP_OMZ_INSTALL" != "true" ]; then
    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Check default shell
if [ "$SHELL" == "/bin/zsh" ]; then
    echo "zsh already default shell"
    SKIP_CHANGE_SHELL="true"
fi

if [ "$SKIP_CHANGE_SHELL" != "true" ]; then
    # change default shell in /etc/passwd
    username=$(whoami)
    sudo sed -i "s|/home/${username}:/bin/.*|/home/${username}:/bin/zsh|g" /etc/passwd
fi