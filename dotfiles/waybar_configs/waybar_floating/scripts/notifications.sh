#!/usr/bin/env bash

# Waybar signal RTMIN+8
SIGNAL=8

if [[ "$1" == "toggle" ]]; then
  if command -v dunstctl >/dev/null 2>&1; then
    dunstctl set-paused toggle 2>/dev/null || true
  fi
  pkill -RTMIN+${SIGNAL} waybar 2>/dev/null || true
  exit 0
fi

paused="false"
waiting=0

if command -v dunstctl >/dev/null 2>&1; then
  paused=$(dunstctl is-paused 2>/dev/null || echo "false")
  waiting=$(dunstctl count waiting 2>/dev/null || echo 0)
fi

if [[ "$paused" == "true" ]]; then
  if [[ "$waiting" -gt 0 ]]; then
    text="<span color='#ea6962'> 󰂛 </span>$waiting "
    tooltip="Notifications: Disabled (DND)\n$waiting notifications waiting\nLeft-click: Enable notifications\nRight-click: View history"
  else
    text="<span color='#ea6962'> 󰂛 </span>"
    tooltip="Notifications: Disabled (Do Not Disturb)\nLeft-click: Enable notifications\nRight-click: View history"
  fi
  class="paused"
else
  text="<span color='#83a598'> 󰂚 </span>"
  tooltip="Notifications: Enabled\nLeft-click: Enable Do Not Disturb\nRight-click: View history"
  class="normal"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$class"
