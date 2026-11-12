{ config, pkgs, inputs, ... }:

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
    gitui
    claude-code


  
    # Messaging
    telegram-desktop
    discord
    # Desktop utilities
    libnotify
    wl-clipboard
    nautilus
    ranger
    brightnessctl
    playerctl
    lm_sensors
    pavucontrol

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
    sunshine
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
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/btop";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/fish";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/kitty";
    ".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/vscode/User/settings.json";
    ".vscode/extensions/noctalia-theme".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/vscode/extensions/noctalia-theme";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/fastfetch";
    ".config/tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/tmux/tmux.conf";
    ".config/tmux/cheatsheet.txt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/tmux/cheatsheet.txt";
    ".config/wireplumber".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/wireplumber";
    ".config/custom_scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/custom_scripts";
    ".config/walls".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/walls";
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
