#!/usr/bin/env bash

# Battery status script for Hyprlock (Gruvbox style)
for bat in /sys/class/power_supply/BAT*; do
    if [ -d "$bat" ]; then
        capacity=$(cat "$bat/capacity" 2>/dev/null)
        status=$(cat "$bat/status" 2>/dev/null)
        
        if [ "$status" = "Charging" ]; then
            icon="󰂄"
        elif [ -n "$capacity" ]; then
            if [ "$capacity" -ge 90 ]; then icon="󰁹"
            elif [ "$capacity" -ge 80 ]; then icon="󰂂"
            elif [ "$capacity" -ge 70 ]; then icon="󰂁"
            elif [ "$capacity" -ge 60 ]; then icon="󰂀"
            elif [ "$capacity" -ge 50 ]; then icon="󰁿"
            elif [ "$capacity" -ge 40 ]; then icon="󰁾"
            elif [ "$capacity" -ge 30 ]; then icon="󰁽"
            elif [ "$capacity" -ge 20 ]; then icon="󰁼"
            elif [ "$capacity" -ge 10 ]; then icon="󰁻"
            else icon="󰁺"
            fi
        fi
        
        echo "$icon $capacity%"
        exit 0
    fi
done

# Fallback for desktops on AC
echo "󰚥 AC"
