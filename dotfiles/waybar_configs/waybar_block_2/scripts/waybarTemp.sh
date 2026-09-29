#!/usr/bin/env bash

TEMP=""
if command -v sensors >/dev/null 2>&1; then
  TEMP=$(sensors | grep -m 1 'Package id 0' | awk '{print $4}' | tr -d '+°C')
  if [[ -z "$TEMP" ]]; then
    TEMP=$(sensors | grep -m 1 'edge' | awk '{print $2}' | tr -d '+°C')
  fi
  if [[ -z "$TEMP" ]]; then
    TEMP=$(sensors | grep -m 1 'Core 0' | awk '{print $3}' | tr -d '+°C')
  fi
fi

if [[ -z "$TEMP" ]] && [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
  raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
  if [[ -n "$raw" ]]; then
    TEMP=$(( raw / 1000 ))
  fi
fi

if [[ -z "$TEMP" ]]; then
  CLASS="unknown"
  FORMAT="<span color='#ebdbb2'>  </span> N/A°C "
  printf '{"text":"%s","class":"%s"}\n' "$FORMAT" "$CLASS"
  exit 0
fi

TEMP_INT=$(printf "%.0f" "$TEMP")

if (( TEMP_INT >= 70 )); then
  CLASS="critical"
  FORMAT="<span color='#cc241d'>  </span>${TEMP_INT}°C"
else
  CLASS="normal"
  FORMAT="<span color='#d8a657'> 󰴈 </span>${TEMP_INT}°C"
fi

printf '{"text":"%s","class":"%s"}\n' "$FORMAT" "$CLASS"
