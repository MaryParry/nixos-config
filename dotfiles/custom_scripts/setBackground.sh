#!/usr/bin/env bash

set_background() {
  local wall_name=""
  if [[ -f "$HOME/.cache/wall.txt" ]]; then
    wall_name="$(<"$HOME/.cache/wall.txt")"
  fi

  pkill -x .swaybg-wrapped 2>/dev/null || true
  pkill -x swaybg 2>/dev/null || true

  if [[ -n "$wall_name" && -f "$wall_name" ]]; then
    ln -sfn "$wall_name" "$HOME/.cache/current_wallpaper.png"
    setsid -f swaybg -i "$wall_name" -m fill >/dev/null 2>&1
  else
    local default_wall="$HOME/.config/walls/wall.png"
    if [[ ! -f "$default_wall" ]]; then
      default_wall="/etc/nixos/dotfiles/walls/wall.png"
    fi
    setsid -f swaybg -i "$default_wall" -m fill >/dev/null 2>&1
  fi
  exit 0
}

set_background
