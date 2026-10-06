#!/usr/bin/env bash

# Music status script for Hyprlock
track=$(playerctl metadata --format '󰎆 {{title}} - {{artist}}' 2>/dev/null | cut -c 1-38)
if [[ -n "$track" ]]; then
    echo "$track"
else
    echo ""
fi
