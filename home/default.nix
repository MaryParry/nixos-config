{ config, pkgs, inputs, ... }:

let
  hyprspacePatched = pkgs.hyprlandPlugins.hyprspace.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "ImanolBarba";
      repo = "Hyprspace";
      rev = "0799be7464fac7ea959b7c6c7809dadd6c21c5aa";
      hash = "sha256-P27tvgpduDsMjk9mSti4We+a3kzYWYWznZKizvnyS+Q=";
    };
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
  home.packages = with pkgs; [
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
    # ollama
    gnupg
    pinentry-tty
    gitui

  
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
    ".config/walls".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/walls";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/dunst";
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  systemd.user.services.hypr-waybar-proxy = {
    Unit = {
      Description = "Waybar Hyprland IPC Proxy for Lua Config";
    };
    Service = {
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
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "always";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
