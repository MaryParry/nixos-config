#!/usr/bin/env bash

# System info script for Hyprlock bottom-left badge
# Read directly from /proc/uptime for 100% reliable, zero-dependency uptime
if [[ -f /proc/uptime ]]; then
    IFS=" " read -r up_sec _ < /proc/uptime
    total_seconds=${up_sec%%.*}
    days=$(( total_seconds / 86400 ))
    hours=$(( (total_seconds % 86400) / 3600 ))
    minutes=$(( (total_seconds % 3600) / 60 ))

    if (( days > 0 )); then
        uptime_str="${days}d ${hours}h ${minutes}m"
    elif (( hours > 0 )); then
        uptime_str="${hours}h ${minutes}m"
    else
        uptime_str="${minutes}m"
    fi
else
    uptime_str="0m"
fi

echo "󰔛 up ${uptime_str}   •    NixOS"
