#!/usr/bin/env bash

chosen=$(echo -e "  Power Off\n  Reboot\n⏾  Suspend\n󰗽  Logout" | rofi -dmenu -i -p "Power:" -theme-str 'window {width: 12em;} listview {lines: 4;}')

case "$chosen" in
    "  Power Off") systemctl poweroff ;;
    "  Reboot") systemctl reboot ;;
    "⏾  Suspend") systemctl suspend ;;
    "󰗽  Logout") hyprctl dispatch exit ;;
esac
