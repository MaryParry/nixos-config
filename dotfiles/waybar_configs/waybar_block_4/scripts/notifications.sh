#!/usr/bin/env bash

SIGNAL=8

ensure_dunst() {
  if ! pgrep -x dunst >/dev/null 2>&1 && ! pgrep -x .dunst-wrapped >/dev/null 2>&1; then
    systemctl --user start dunst 2>/dev/null || setsid -f dunst >/dev/null 2>&1
    sleep 0.2
  fi
}

case "$1" in
  toggle)
    ensure_dunst
    dunstctl set-paused toggle 2>/dev/null || true
    pkill -RTMIN+${SIGNAL} waybar 2>/dev/null || true
    exit 0
    ;;
  history)
    ensure_dunst
    dunstctl history-pop 2>/dev/null || true
    exit 0
    ;;
esac

# Auto-start dunst if it is not running
ensure_dunst

paused="false"
waiting=0

if command -v dunstctl >/dev/null 2>&1; then
  paused=$(dunstctl is-paused 2>/dev/null || echo "false")
  waiting=$(dunstctl count waiting 2>/dev/null || echo 0)
fi

if [[ "$paused" == "true" ]]; then
  if [[ "$waiting" -gt 0 ]]; then
    text="<span color='#ea6962'> 󰂛 </span>$waiting "
    tooltip="Notifications: Disabled (DND)\n$waiting notification(s) waiting\nLeft-click: Enable notifications\nRight-click: Pop history"
  else
    text="<span color='#ea6962'> 󰂛 </span>"
    tooltip="Notifications: Disabled (Do Not Disturb)\nLeft-click: Enable notifications\nRight-click: Pop history"
  fi
  class="paused"
else
  text="<span color='#83a598'> 󰂚 </span>"
  tooltip="Notifications: Enabled\nLeft-click: Enable Do Not Disturb\nRight-click: Pop history"
  class="normal"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$class"
