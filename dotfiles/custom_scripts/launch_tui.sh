#!/usr/bin/env bash

launch_tui_app() {
  local term="kitty"
  if command -v footclient >/dev/null 2>&1 && pgrep -x foot --server >/dev/null 2>&1; then
    term="footclient"
  elif command -v foot >/dev/null 2>&1; then
    term="foot"
  elif command -v kitty >/dev/null 2>&1; then
    term="kitty"
  fi

  local base_cmd="${1}"

  # validate if base command is already running
  if pgrep -x "$base_cmd" >/dev/null; then
    notify-send -u low "$base_cmd is already running"
  else
    nohup "$term" -e "$@" >/dev/null 2>&1 &
  fi
}

launch_tui_app "$@"
