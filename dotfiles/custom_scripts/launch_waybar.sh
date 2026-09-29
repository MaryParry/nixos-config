#!/usr/bin/env bash

# Kill any existing waybar binaries without matching script names
pkill -x waybar 2>/dev/null || true
pkill -x .waybar-wrapped 2>/dev/null || true
while pgrep -x .waybar-wrapped >/dev/null || pgrep -x waybar >/dev/null; do sleep 0.1; done

# Ensure systemd proxy service is active
if ! systemctl --user is-active --quiet hypr-waybar-proxy.service; then
  systemctl --user start hypr-waybar-proxy.service
  sleep 0.2
fi

# Launch waybar pointing to the proxy signature
export HYPRLAND_INSTANCE_SIGNATURE="waybar-proxy"
setsid -f waybar >/dev/null 2>&1
