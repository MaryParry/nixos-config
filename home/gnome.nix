{ config, pkgs, lib, ... }:

let
  # nixpkgs lags behind; pull the newer release straight from extensions.gnome.org
  lockscreenStudioLatest = pkgs.gnomeExtensions.lockscreen-studio.overrideAttrs (_: {
    version = "11";
    src = pkgs.fetchzip {
      url = "https://extensions.gnome.org/extension-data/lockscreen-studiopedro.projects.v11.shell-extension.zip";
      hash = "sha256-81BkTN29PlS5ht39+8Jd7OpqncdBvBGyaLzkXEfsNbk=";
      stripRoot = false;
    };
  });

  # Dash to Dock has no "gap from screen edge" setting; lift the bottom dock off the edge
  dashToDockPadded = pkgs.gnomeExtensions.dash-to-dock.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      echo '#dashtodockContainer.bottom #dash { margin-bottom: 10px; }' \
        >> $out/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/stylesheet.css
    '';
  });

  # Even out top-bar icon spacing; edit dotfiles/gnome/panel.css to tweak
  justPerfectionPanelSpacing = pkgs.gnomeExtensions.just-perfection.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cat ${../dotfiles/gnome/panel.css} \
        >> $out/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/stylesheet.css
    '';
  });
in
{
  home.packages = with pkgs; [
    (writeShellScriptBin "gnome-save" ''
      ${dconf}/bin/dconf dump /org/gnome/shell/extensions/ > /etc/nixos/dotfiles/gnome/extensions.ini
      ${git}/bin/git -C /etc/nixos add dotfiles/gnome/extensions.ini
      echo "Saved GNOME extension settings to /etc/nixos/dotfiles/gnome/extensions.ini"
    '')
    gruvbox-plus-icons
  ];

  home.file.".config/walls".source = config.lib.file.mkOutOfStoreSymlink "/home/saponela/Pictures/wall";

  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    exec = "spotify %U";
    icon = "/home/saponela/.local/share/icons/custom_spotify.png";
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.phinger-cursors-gruvbox-material;
    name = "phinger-cursors-gruvbox-material";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };

  home.activation.linkWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/.local/share/backgrounds
    for f in $HOME/Pictures/wall/*; do
      if [ -f "$f" ]; then
        $DRY_RUN_CMD ln -sfn "$f" "$HOME/.local/share/backgrounds/$(basename "$f")"
      fi
    done
  '';

  # Installs and enables GNOME extensions
  programs.gnome-shell = {
    enable = true;
    extensions = map (p: { package = p; }) (with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      clipboard-indicator
      caffeine
      vitals
      compiz-alike-magic-lamp-effect
      desktop-icons-ng-ding
    ]) ++ [ { package = lockscreenStudioLatest; } { package = dashToDockPadded; } { package = justPerfectionPanelSpacing; } ];
  };

  # Extension *settings* are owned by the GUI, not dconf.settings, so they never get reset.
  # Run `gnome-save` to snapshot them into the repo; a fresh machine restores that snapshot once.
  home.activation.restoreGnomeExtensionSettings = lib.hm.dag.entryAfter [ "dconfSettings" ] ''
    if [ -z "$(${pkgs.dconf}/bin/dconf list /org/gnome/shell/extensions/)" ]; then
      $DRY_RUN_CMD ${pkgs.dbus}/bin/dbus-run-session --dbus-daemon=${pkgs.dbus}/bin/dbus-daemon \
        ${pkgs.dconf}/bin/dconf load /org/gnome/shell/extensions/ < ${../dotfiles/gnome/extensions.ini}
    fi
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-animations = true;
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      cursor-theme = "phinger-cursors-gruvbox-material";
      cursor-size = 24;
      icon-theme = "Gruvbox-Plus-Dark";
      font-name = "Roboto 11";
      document-font-name = "Roboto 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      enable-hot-corners = false;
      clock-show-weekday = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      action-middle-click-titlebar = "minimize";
      focus-mode = "click";
      resize-with-right-button = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-input-source = [ "<Super>space" "XF86Keyboard" ];
      switch-input-source-backward = [ "<Shift><Super>space" "<Shift>XF86Keyboard" ];
      toggle-fullscreen = [ "<Super>f" "F11" ];

      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];

      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };

    "org/gnome/shell" = {
      # enabled-extensions is generated by programs.gnome-shell below;
      # clear disabled-extensions so a GUI toggle can't override it
      disabled-extensions = [];
      favorite-apps = [
        "zen-beta.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "code.desktop"
        "spotify.desktop"
        "org.telegram.desktop.desktop"
        "legcord.desktop"
        "com.stremio.Stremio.desktop"
        "net.lutris.lutris.desktop"
        "steam.desktop"
        "obs-studio.desktop"
        "obsidian.desktop"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Terminal (Ctrl-Alt-T)";
      command = "kitty";
      binding = "<Control><Alt>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch Terminal (Super-Return)";
      command = "kitty";
      binding = "<Super>Return";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.gvariant.mkTuple [ "xkb" "us" ])
        (lib.gvariant.mkTuple [ "xkb" "ge" ])
      ];
      xkb-options = [ "grp:win_space_toggle" "caps:swapescape" ];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = false;
    };

    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = false;
    };
  };
}
