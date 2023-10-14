#!/usr/bin/env bash
# Additional programs
export PATH="$PATH:/home/mbarria/.config/emacs/bin"
# Alises
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# NixOS specific configuration
if [[ "$(hostname)" == "nixlaptop" ]]; then
    # Make sure that NixOS looks for my config
    # Redundant as it should be linked, but shouldn't hurt
    NIX_CONF_DIR="$HOME/.config/system/nixlaptop"
fi
