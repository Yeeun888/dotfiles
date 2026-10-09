#!/bin/bash

# Check STOW availability
if ! which stow > /dev/null 2>&1; then
    echo "Error: GNU Stow is not installed. Please install it before running this script."
    exit 1
fi

echo "Stow found, continuing..."

# Create Symlinks
stow --target=$HOME wezterm
stow --target=$HOME zsh
stow --target=$HOME vim
stow --target=$HOME nvim
