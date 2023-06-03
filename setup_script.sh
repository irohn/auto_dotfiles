#!/bin/zsh

WSL=false

# Determine which OS we're running on
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected"
    OS="linux"
    if wsl.exe --version > /dev/null 2>&1; then
        echo "WSL detected"
        WSL=true
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Mac OSX detected"
    OS="mac"
else
    echo "OS not supported"
    OS="unknown"
    exit 1
fi


# ---


# Make .config directory if it doesn't exist
[[ -d ~/.config ]] || mkdir ~/.config


# --- symlinks


# Starship config
ln -svf "$(pwd)"/.config/starship.toml "$HOME"/.config/

# Aliases and functions
ln -svf "$(pwd)"/.config/aliases.zsh "$HOME"/.config/
ln -svf "$(pwd)"/.config/functions.zsh "$HOME"/.config/

# Neovim config
ln -svf "$(pwd)"/.config/nvim "$HOME"/.config/

# Alacritty config
if [ $OS = "linux" ]; then
    if [ $WSL = "true" ]; then
        windows_username=$(powershell.exe -Command "Set-Location -Path C:\Users; cmd /c echo %username%")
        windows_username=$(echo $windows_username | tr -d '\r')
        windows_path="/mnt/c/Users/$windows_username/AppData/Roaming/alacritty"
        echo "WSL detected, copying files manually into $windows_path"
        cp -r "$(pwd)/.config/alacritty" "$windows_path"
        echo "populating alacritty.yml..."
        echo "import:\n  - $windows_path/default.yml\n  - $windows_path/windows.yml" | sed 's|/mnt/c|C:|g' > "$windows_path/alacritty.yml"
    else
        ln -svf "$(pwd)"/.config/alacritty "$HOME"/.config/
    fi
elif [ $OS = "mac" ]; then
    echo "MacOS detected, copying files manually"
    cp -r "$(pwd)"/.config/alacritty "$HOME"/.config/alacritty
    echo "populating alacritty.yml..."
    echo "import:\n  - $HOME/.config/alacritty/default.yml\n  - $HOME/.config/alacritty/mac.yml" > "$HOME"/.config/alacritty/alacritty.yml
else
    echo "OS not supported"
fi

# symlinks for home config files
ln -svf "$(pwd)"/.zshrc "$HOME"/
ln -svf "$(pwd)"/.tmux.conf "$HOME"/
ln -svf "$(pwd)"/.hushlogin "$HOME"/
