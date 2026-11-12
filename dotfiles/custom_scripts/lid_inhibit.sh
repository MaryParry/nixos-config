#!/usr/bin/env bash
# Toggle "don't suspend on lid close" by holding a logind handle-lid-switch inhibitor.
# Usage: lid_inhibit.sh [toggle]   (no args prints waybar JSON)
# Toggled via right-click on the waybar caffeine (idle_inhibitor) button.

UNIT="lid-inhibit"
SIGNAL=9

is_active() { systemctl --user is-active --quiet "$UNIT"; }

if [[ "$1" == "toggle" ]]; then
  if is_active; then
    systemctl --user stop "$UNIT"
    notify-send -t 2000 "Lid close" "Suspends normally" 2>/dev/null || true
  else
    systemd-run --user --quiet --unit="$UNIT" \
      systemd-inhibit --what=handle-lid-switch --mode=block \
        --who="lid_inhibit.sh" --why="Lid-close suspend disabled by user" \
        sleep infinity
    notify-send -t 2000 "Lid close" "Will NOT suspend" 2>/dev/null || true
  fi
  pkill -RTMIN+${SIGNAL} waybar 2>/dev/null || true
  exit 0
fi

# Only shown while active (empty text hides the waybar module)
if is_active; then
  printf '{"text":"%s","tooltip":"%s","class":"active"}\n' \
    "<span color='#d8a657'> 󰌢 </span>" "Lid close: ignored (stays awake)\nClick: restore suspend on lid close"
else
  printf '{"text":"","class":"normal"}\n'
fi
