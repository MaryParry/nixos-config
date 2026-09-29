#!/usr/bin/env bash

# Detect desktop / wayland
suspend="systemctl suspend"

if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    logout="hyprctl dispatch exit"
elif [ "$XDG_CURRENT_DESKTOP" = "sway:wlroots" ] || [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    logout="swaymsg exit"
else
    logout="loginctl terminate-user $USER"
fi

lock="loginctl lock-session"

options=(
    "LOCK"
    "SUSPEND"
    "LOG-OUT"
    "RESTART"
    "POWER-OFF"
)

if command -v rofi >/dev/null 2>&1; then
  chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -theme-str '@import "~/.config/rofi/themes/powermenu.rasi"')
else
  chosen=$(printf '%s\n' "${options[@]}" | vicinae dmenu -p "Power")
fi

case "$chosen" in
    "LOCK") eval "$lock" ;;
    "SUSPEND") eval "$suspend" ;;
    "LOG-OUT") eval "$logout" ;;
    "RESTART") systemctl reboot ;;
    "POWER-OFF") systemctl poweroff ;;
    *) exit 1 ;;
esac
