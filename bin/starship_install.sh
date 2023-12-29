#!/bin/bash

curl -sS https://starship.rs/install.sh | sh

# Make sure we eval starship in .zshrc
if ! grep -q "starship init zsh" ~/.zshrc; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi
