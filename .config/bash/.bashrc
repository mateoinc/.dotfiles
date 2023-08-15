#!/usr/bin/env bash
# Additional programs
export PATH="$PATH:/home/mbarria/.config/emacs/bin"
# Set up my default venv for Python
if [ -f "$HOME/.virtualenvs/main/bin/activate" ]; then
    source "$HOME/.virtualenvs/main/bin/activate"
fi
# Alises
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
