#!/bin/sh

USER=$(whoami)
KERNEL_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')

printf "Running as user: %s\n" "$USER"
printf "Kernel name: %s\n" "$KERNEL_NAME"

printf "Checking if XDG_CONFIG_HOME is set...\n"
if [ -z "$XDG_CONFIG_HOME" ]; then
    printf "XDG_CONFIG_HOME is not set, setting to default value...\n"
    export XDG_CONFIG_HOME="$HOME/.config"
else
    printf "XDG_CONFIG_HOME is set to %s\n" "$XDG_CONFIG_HOME"
fi

exit 0

# Make .config directory if it doesn't exist
[[ -d ~/.config ]] || mkdir ~/.config

# Starship config
ln -svf "$(pwd)"/.config/starship.toml "$HOME"/.config

# Aliases and functions
ln -svf "$(pwd)"/.config/aliases.zsh "$HOME"/.config
ln -svf "$(pwd)"/.config/functions.zsh "$HOME"/.config

# Neovim config
git clone https://github.com/irohn/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Alacritty config
echo "[Alacritty] Setting up..."
if [ $OS = "linux" ]; then
    if [ $WSL = "true" ]; then
        windows_username=$(powershell.exe -Command "Set-Location -Path C:\Users; cmd /c echo %username%")
        windows_username=$(echo $windows_username | tr -d '\r')
        windows_path="/mnt/c/Users/$windows_username/AppData/Roaming/alacritty"
        echo "[Alacritty] WSL detected, copying files manually into $windows_path"
        cp -r "$(pwd)/.config/alacritty" "$windows_path"
        echo "[Alacritty] populating alacritty.yml..."
        echo "[Alacritty] import:\n  - $windows_path/default.yml\n  - $windows_path/windows.yml" | sed 's|/mnt/c|C:|g' > "$windows_path/alacritty.yml"
    else
        ln -svf "$(pwd)"/.config/alacritty "$HOME"/.config
    fi
elif [ $OS = "mac" ]; then
    echo "[Alacritty] MacOS detected, copying files manually"
    cp -r "$(pwd)"/.config/alacritty "$HOME"/.config/alacritty
    echo "[Alacritty] populating alacritty.yml..."
    echo "[Alacritty] import:\n  - $HOME/.config/alacritty/default.yml\n  - $HOME/.config/alacritty/mac.yml" > "$HOME"/.config/alacritty/alacritty.yml
else
    echo "[Alacritty] OS not supported"
fi

# symlinks for tmux config and plugins
ln -svf "$(pwd)"/.config/tmux "$HOME"/.config
ln -svf "$(pwd)"/.tmux "$HOME"

# symlinks for home config files
ln -svf "$(pwd)"/.zshrc "$HOME"
ln -svf "$(pwd)"/.hushlogin "$HOME"

