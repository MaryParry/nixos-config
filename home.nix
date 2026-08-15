{ config, pkgs, inputs, ... }:

let
  hyprspacePatched = pkgs.hyprlandPlugins.hyprspace.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/main.cpp \
        --replace-fail "if (Config::disableGestures) return;" "return;"
      substituteInPlace src/Input.cpp \
        --replace-fail 'HyprlandAPI::getConfigValue(pHandle, "gestures:workspace_swipe_distance")->getValue()' '300' \
        --replace-fail 'HyprlandAPI::getConfigValue(pHandle, "gestures:workspace_swipe_min_speed_to_force")->getValue()' '30' \
        --replace-fail 'HyprlandAPI::getConfigValue(pHandle, "gestures:workspace_swipe_cancel_ratio")->getValue()' '0.5'
    '';
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
    inputs.plasma-manager.homeModules.plasma-manager
    ./lazyvim.nix
    ./plasma.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hyprspacePatched
    # Development
    vscode
    jdk21_headless
    git
    jetbrains.idea
    gh
    docker
    pnpm
    nodejs
    postman
    # ollama
    jetbrains.pycharm
    gnupg
    pinentry-tty


  
    # Messaging
    telegram-desktop
    discord
    fluffychat
    # Wayland / Hyprland Essentials
    vicinae
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
    
    # Terminal & Shell
    kitty
    fish
    btop
    bat
    tmux
    
    # Tools
    fastfetch
    gemini-cli
    upower
    duf 
    cowsay
    obsidian
    anki
    obs-studio
    jp2a
    keymapper #i hate copilot i hate copilot 
    moonlight-qt
    sunshine
    mangohud
    logmein-hamachi
    pamixer
    kdePackages.kdeconnect-kde
    pulseaudio
    paprefs
    blender #vTraining
    krita
    reco
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
    heroic
    protonup-qt
    ];




  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/btop";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fish";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/kitty";
    ".config/noctalia".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/noctalia";
    ".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/vscode/User/settings.json";
    ".vscode/extensions/noctalia-theme".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/vscode/extensions/noctalia-theme";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fastfetch";
    ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/tmux/tmux.conf";
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
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
