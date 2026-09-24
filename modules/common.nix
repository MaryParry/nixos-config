{ config, pkgs, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # Bootloader & tmp settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = false;

  # Enable networking via NetworkManager
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tbilisi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.tailscale.enable = true;

  # Display Manager & Desktop Environments
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Configure keymap in X11 & Wayland
  services.xserver.xkb = {
    layout = "us,ge";
    options = "grp:alt_shift_toggle,grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  # Define a user account.
  users.users.saponela = {
    isNormalUser = true;
    description = "saponela";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://noctalia.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  # Install firefox.
  programs.firefox.enable = true;

  programs.fish.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        {
          src = pkgs.fetchFromGitHub {
            owner = "BitesizedLion";
            repo = "AnonymizedRadios";
            rev = "1c843dcb0a7b43da9932ee1cc9b3557f0a7f8ba6";
            sha256 = "0nqnpvnhk7gqh12ln3ra1gpdny3z262w7n475fs0m72gg2hxbb8w";
          };
          name = "AnonymizedRadios.js";
        }
      ];
      theme = spicePkgs.themes.retroBlur // { name = "marketplace"; };
    };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        blink-cmp = prev.vimPlugins.blink-cmp.overrideAttrs (oldAttrs: {
          version = "v${oldAttrs.version}";
          src = builtins.removeAttrs oldAttrs.src [ "rev" ];
          __intentionallyOverridingVersion = true;
        });
      };
    })
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
    (lutris.override {
      extraPkgs = pkgs: with pkgs; [
        wineWow64Packages.stable
        winetricks
        gnutls
        openldap
        libvdpau
        vulkan-loader
      ];
    })
    wineWow64Packages.stable
    bibata-cursors
    vulkan-loader
    vulkan-tools
  ];

  environment.sessionVariables = {
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    TMPDIR = "/home/saponela/.cache/tmp";
  };

  # Services
  services.ollama = {
    enable = true;
    loadModels = [
      "qwen2.5-coder:1.5b"
    ];
  };
  services.upower.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;
  services.logmein-hamachi.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;

  networking.firewall.allowedTCPPorts = [
    47984
    47989
    47990
    48010
  ];

  networking.firewall.allowedUDPPorts = [
    34197
    47998
    47999
    48000
    48002
    48010
  ];

  networking.firewall.allowedTCPPortRanges = [
    { from = 1714; to = 1764; } # KDE Connect
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 1714; to = 1764; } # KDE Connect
  ];

  system.stateVersion = "25.11";
}
