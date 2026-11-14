#!/usr/bin/env bash

# Select item from cliphist using custom rofi theme
selected=$(cliphist list | rofi -dmenu -theme "$HOME/.config/rofi/clipboard.rasi" -p ">")

# If Esc was pressed or nothing selected, exit cleanly without touching clipboard
if [ -n "$selected" ]; then
    cliphist decode <<< "$selected" | wl-copy
fi
