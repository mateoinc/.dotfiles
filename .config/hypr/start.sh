#!/usr/bin/env bash

# wallpaper daemon
swww init &
# setting wallpaper
swww img ~/Pictures/Sea-of-Stars-Poster.png

# network
np-applet --indicator &

# the bar
waybar &

# clipboard
copyq --start-server


# dunst
dunst
