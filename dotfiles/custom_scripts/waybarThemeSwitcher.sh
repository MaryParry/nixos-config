#!/usr/bin/env bash

switch_waybar_themes() {
  local waybar_themes_directory="/etc/nixos/dotfiles/waybar_configs"
  if [[ ! -d "$waybar_themes_directory" ]]; then
    waybar_themes_directory="$HOME/.config/waybar_configs"
  fi
  local waybar_target_directory="/etc/nixos/dotfiles/waybar"
  local waybar_themes
  local selected_waybar_theme
  local selected_path

  # store theme directories in an array
  mapfile -t waybar_themes < <(
    find "$waybar_themes_directory" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"
  )

  # theme selection prompt
  if command -v rofi >/dev/null 2>&1; then
    selected_waybar_theme="$(
      printf "%s\n" "${waybar_themes[@]}" |
      sort |
      rofi -dmenu -p "Themes"
    )"
  elif command -v vicinae >/dev/null 2>&1; then
    selected_waybar_theme="$(
      printf "%s\n" "${waybar_themes[@]}" |
      sort |
      vicinae dmenu -p "Themes"
    )"
  else
    notify-send "Waybar" "No menu launcher found (rofi/vicinae)"
    return 1
  fi

  # notify if a theme is not selected
  if [[ -z "$selected_waybar_theme" ]]; then
    return 0
  fi
  
  # full selected path
  selected_path="$waybar_themes_directory/$selected_waybar_theme"

  # handle wrong theme name
  [[ -d "$selected_path" ]] || {
    notify-send "Waybar" "Config \"$selected_waybar_theme\" not found"
    return 1
  }

  # Copy the selected theme into waybar dotfiles
  if [[ -d "$waybar_target_directory" ]]; then
    cp -r "$selected_path"/* "$waybar_target_directory/"
  fi

  # In case ~/.config/waybar is directly linked
  if [[ -L "$HOME/.config/waybar" && ! -e "$waybar_target_directory" ]]; then
    ln -sfn "$selected_path" "$HOME/.config/waybar"
  fi

  # restart waybar session
  local launcher_script="/etc/nixos/dotfiles/custom_scripts/launch_waybar.sh"
  if [[ ! -x "$launcher_script" ]]; then
    launcher_script="$HOME/.config/custom_scripts/launch_waybar.sh"
  fi
  "$launcher_script"
  notify-send "Waybar" "Active theme: $selected_waybar_theme"
}

switch_waybar_themes
