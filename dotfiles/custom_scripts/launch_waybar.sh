#!/usr/bin/env bash

# Kill any existing waybar binaries without matching script names
pkill -x waybar 2>/dev/null || true
pkill -x .waybar-wrapped 2>/dev/null || true
while pgrep -x .waybar-wrapped >/dev/null || pgrep -x waybar >/dev/null; do sleep 0.1; done

# Ensure systemd proxy service is active
if ! systemctl --user is-active --quiet hypr-waybar-proxy.service 2>/dev/null; then
  systemctl --user start hypr-waybar-proxy.service 2>/dev/null
  sleep 0.2
fi

# Fallback: if proxy service is not running via systemd, run proxy script directly
if ! pgrep -f "hypr_waybar_proxy.js" >/dev/null; then
  proxy_script="/etc/nixos/dotfiles/custom_scripts/hypr_waybar_proxy.js"
  if [[ ! -f "$proxy_script" ]]; then
    proxy_script="$HOME/.config/custom_scripts/hypr_waybar_proxy.js"
  fi
  if command -v node >/dev/null 2>&1 && [[ -f "$proxy_script" ]]; then
    node "$proxy_script" >/dev/null 2>&1 &
    sleep 0.2
  fi
fi

# Launch waybar pointing to the proxy signature
export HYPRLAND_INSTANCE_SIGNATURE="waybar-proxy"
setsid -f waybar >/dev/null 2>&1
