#!/bin/sh

# Make .config directory if it doesn't exist
[[ -d ~/.config ]] || mkdir ~/.config

# Backup the old config files if they exist
# [[ -f ~/.config/starship.toml ]] && mv ~/.config/starship.toml ~/.config/starship.toml.bak
# [[ -f ~/.config/aliases.zsh ]] && mv ~/.config/aliases.zsh ~/.config/aliases.zsh.bak
# [[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak
# [[ -d ~/.config/nvim ]] && mv ~/.config/nvim ~/.config/nvim.bak

# symlink the config files
ln -svf "$(pwd)"/.config/starship.toml "$HOME"/.config/
ln -svf "$(pwd)"/.config/aliases.zsh "$HOME"/.config/
ln -svf "$(pwd)"/.zshrc "$HOME"/
ln -svf "$(pwd)"/.config/nvim "$HOME"/.config/
ln -svf "$(pwd)"/.hushlogin "$HOME"/