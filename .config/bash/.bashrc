#!/usr/bin/env bash
# Additional programs
export PATH="$PATH:/home/mbarria/.config/emacs/bin"
# Set up my default venv for Python
if [ -f "$HOME/.virtualenvs/main/bin/activate" ]; then
    source "$HOME/.virtualenvs/main/bin/activate"
fi
# Alises
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# NixOS specific configuration
if [[ "$(hostname)" == "nixlaptop" ]]; then
    # Make sure that NixOS looks for my config
    # Redundant as it should be linked, but shouldn't hurt
    NIX_CONF_DIR="$HOME/.config/system/nixlaptop"
fi
