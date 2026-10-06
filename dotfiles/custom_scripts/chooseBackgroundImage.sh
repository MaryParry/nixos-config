#!/usr/bin/env bash

# Directories to search for wallpapers
wallpaper_dirs=()
if [[ -d "$HOME/Pictures/wall" ]]; then
  wallpaper_dirs+=("$HOME/Pictures/wall")
fi
if [[ -d "$HOME/Pictures" ]]; then
  wallpaper_dirs+=("$HOME/Pictures")
fi
if [[ -d "$HOME/Pictures/backgrounds" ]]; then
  wallpaper_dirs+=("$HOME/Pictures/backgrounds")
fi
if [[ ${#wallpaper_dirs[@]} -eq 0 ]]; then
  wallpaper_dirs=("/etc/nixos/pics/wallpapers")
fi

theme="$HOME/.config/rofi/themes/wallpicker.rasi"
cache_file="$HOME/.cache/wall.txt"

show_wallpapers() {
  printf '\0keep-selection\x1ftrue\n'

  local file
  local name

  while IFS= read -r -d '' file; do
    name="${file##*/}"
    printf '%s\0icon\x1f%s\n' "$name" "$file"
  done < <(
    find -L "${wallpaper_dirs[@]}" \
      -maxdepth 1 \
      -type f \
      \( \
      -iname "*.jpg" -o \
      -iname "*.jpeg" -o \
      -iname "*.png" -o \
      -iname "*.gif" -o \
      -iname "*.bmp" -o \
      -iname "*.webp" \
      \) \
      -print0 |
      sort -z -u
  )
}

set_wallpaper() {
  local selected_wall="$1"
  [[ -z "$selected_wall" ]] && return

  local wall_path
  wall_path="$(
    find -L "${wallpaper_dirs[@]}" \
      -maxdepth 1 \
      -type f \
      -name "$selected_wall" \
      -print -quit
  )"

  [[ -z "$wall_path" ]] && return

  mkdir -p "$(dirname "$cache_file")"
  echo "$wall_path" > "$cache_file"
  ln -sfn "$wall_path" "$HOME/.cache/current_wallpaper.png"

  pkill -x .swaybg-wrapped 2>/dev/null || true
  pkill -x swaybg 2>/dev/null || true

  setsid -f swaybg \
    -i "$wall_path" \
    -m fill \
    >/dev/null 2>&1
}

if [[ -n "$ROFI_RETV" ]]; then
  case "$ROFI_RETV" in
    # Initial call
    0)
    show_wallpapers
    ;;
    1)
    set_wallpaper "$1"
    show_wallpapers
    ;;
  esac
  exit 0
fi

if ! find -L "${wallpaper_dirs[@]}" \
  -maxdepth 1 \
  -type f \
  \( \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.png" -o \
  -iname "*.gif" -o \
  -iname "*.bmp" -o \
  -iname "*.webp" \
  \) \
  -print -quit |
  grep -q .
then
  notify-send \
    "Wallpaper Picker" \
    "No wallpapers found in ${wallpaper_dirs[*]}"

  exit 1
fi

exec rofi \
  -show walls \
  -modi "walls:$0" \
  -show-icons \
  -theme "$theme"
