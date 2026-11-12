{ config, pkgs, inputs, lib, ... }:

let
  hyprspacePatched = pkgs.hyprlandPlugins.hyprspace.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "ImanolBarba";
      repo = "Hyprspace";
      rev = "0799be7464fac7ea959b7c6c7809dadd6c21c5aa";
      hash = "sha256-P27tvgpduDsMjk9mSti4We+a3kzYWYWznZKizvnyS+Q=";
    };
  });

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

  legcordPatched = pkgs.legcord.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/Legcord/Legcord/commit/133df0f6209e44af15b360a6adda9a9d6fa6e146.patch";
        hash = "sha256-+Pop9+1Nf3T7DPQ+QbXvZ04T2hQqkQhPbevNE7JjBog=";
      })
    ];
  });
in
{
  home.username = "saponela";
  home.homeDirectory = "/home/saponela";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home Manager
  # release notes for a list of state version changes in each release.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  imports = [
    inputs.lazyvim.homeManagerModules.default
    ./lazyvim.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  systemd.user.services.kdeconnect.Install.WantedBy = [ "default.target" ];

  programs.claude-code = {
    enable = true;
    skills = {
      ponytail = "${inputs.ponytail-skill}/skills/ponytail";
      agent-browser = "${inputs.agent-browser-skill}/skills/agent-browser";
      python-best-practices = "${inputs.bigboss-claude-code}/.claude/skills/python-best-practices";
    };
  };
  # agent-browser's downloaded Chrome won't run on NixOS; use the Nix one
  home.sessionVariables.AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs.google-chrome;
  home.packages = with pkgs; [
    (writeShellScriptBin "gnome-save" ''
      ${dconf}/bin/dconf dump /org/gnome/shell/extensions/ > /etc/nixos/dotfiles/gnome/extensions.ini
      ${git}/bin/git -C /etc/nixos add dotfiles/gnome/extensions.ini
      echo "Saved GNOME extension settings to /etc/nixos/dotfiles/gnome/extensions.ini"
    '')
    hyprspacePatched
    # Development
    vscode
    jdk21_headless
    git
    gh
    docker
    pnpm
    nodejs
    postman
    jupyter #machine learning class
    imagemagick # image & animated gif rendering for jupynvim
    chafa # terminal image fallback
    # ollama
    gnupg
    pinentry-tty
    gitui
    anydesk
    agent-browser 
    proton-vpn

  
    # Messaging
    telegram-desktop
    legcordPatched
    # Wayland / Hyprland Essentials
    hyprpaper
    waybar
    libnotify
    networkmanagerapplet
    polkit_gnome
    wl-clipboard
    grim
    slurp
    swappy
    nautilus
    ranger
    yazi
    ffmpegthumbnailer
    unar
    poppler-utils
    fd
    ripgrep
    fzf
    zoxide
    gruvbox-plus-icons
    brightnessctl
    playerctl
    hypridle
    hyprlock
    lm_sensors
    rofi
    wlsunset
    pavucontrol
    dunst
    libnotify
    swaybg
    swaylock-effects
    
    # Terminal & Shell
    kitty
    fish
    btop
    bat
    tmux
    
    # Tools
    fastfetch
    upower
    duf 
    cowsay
    obsidian
    anki
    obs-studio
    jp2a
    keymapper #i hate copilot i hate copilot 
    moonlight-qt
    mangohud
    pamixer
    pulseaudio
    paprefs
    blender #vTraining
    krita
    reco # voice recorder 
    wiremix

    # Misc
    flatpak
    libreoffice
    webcamoid
    
    # Music & Entertainment
    steam
    qbittorrent
    mpv
    google-chrome
    prismlauncher
    protonup-qt
    ];




  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/btop";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fish";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/kitty";
    ".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/vscode/User/settings.json";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fastfetch";
    ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/tmux/tmux.conf";
    ".config/tmux/cheatsheet.txt".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/tmux/cheatsheet.txt";
    ".config/wireplumber".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wireplumber";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/waybar";
    ".config/waybar_configs".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/waybar_configs";
    ".config/custom_scripts".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/custom_scripts";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/rofi";
    ".config/walls".source = config.lib.file.mkOutOfStoreSymlink "/home/saponela/Pictures/wall";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/dunst";
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/yazi";
    ".cache/tmp/.keep".text = "";
    # ".config/spicetify".source = ./dotfiles/spicetify; # Managed by spicetify-nix
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/saponela/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Default Applications configuration
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen-beta.desktop" ];
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
    };
  };

  xdg.desktopEntries = {
    zen-beta = {
      name = "Zen Browser";
      genericName = "Web Browser";
      exec = "zen-beta %u";
      icon = "zen-browser";
      categories = [ "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
    };
    spotify = {
      name = "Spotify";
      genericName = "Music Player";
      exec = "spotify %U";
      icon = "/home/saponela/.local/share/icons/custom_spotify.png";
      categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    };
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

  systemd.user.services.hypr-waybar-proxy = {
    Unit = {
      Description = "Waybar Hyprland IPC Proxy for Lua Config";
    };
    Service = {
      ExecCondition = "${pkgs.procps}/bin/pgrep -x Hyprland";
      ExecStart = "${pkgs.nodejs}/bin/node /etc/nixos/dotfiles/custom_scripts/hypr_waybar_proxy.js";
      Restart = "always";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.dunst = {
    Unit = {
      Description = "Dunst notification daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" != \"GNOME\" ]'";
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "always";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "default.target" ];
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
