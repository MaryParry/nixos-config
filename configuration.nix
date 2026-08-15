# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader & tmp settings.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = false;

  boot.initrd.luks.devices."luks-c8724694-43ff-4c8d-9f30-c09fd2e85503".device = "/dev/disk/by-uuid/c8724694-43ff-4c8d-9f30-c09fd2e85503";
  networking.hostName = "tetri"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
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

  # Enable graphics support and 32-bit support (required for Steam/Wine)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # For VA-API (video acceleration)
      intel-vaapi-driver # Formerly vaapiIntel
      libvdpau-va-gl
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.tailscale.enable = true;
  # Display Manager & Desktop Environments
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Enable Hyprland & KDE Plasma 6
  programs.hyprland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11 & Wayland
  services.xserver.xkb = {
    layout = "us,ge";
    options = "grp:alt_shift_toggle,grp:win_space_toggle";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            pageup = "home";
            pagedown = "end";
            home = "pageup";
            end = "pagedown";
            esc = "capslock";
            capslock = "esc";
          };
        };
      };
    };
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example sesseon manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

   virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saponela = {
    isNormalUser = true;
    description = "saponela";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [
    "https://cache.nixos.org"
    # "http://192.168.3.224:8080/nixos"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    # "nixos:GHyC7cZlnDApGlXe/KnG4oHSszdJ7Ew7ZXg9Gj/QyfA="
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
    # Add more libraries here as you encounter missing .so errors
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
       shuffle # shuffle+ (special characters are replaced with -)
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

   # KDE Plasma 6 Packages & Utilities
   kdePackages.dolphin
   kdePackages.spectacle
   kdePackages.konsole
   kdePackages.kate
   kdePackages.kcalc
   kdePackages.gwenview
   kdePackages.ark
   kdePackages.plasma-systemmonitor
   kdePackages.kdegraphics-thumbnailers
   kdePackages.ffmpegthumbs
   kdePackages.qtstyleplugin-kvantum
   kdePackages.qt6ct
  ];

  environment.sessionVariables = {
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    TMPDIR = "/home/saponela/.cache/tmp";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
    services.ollama = {
      enable = true;
    };
    services.upower.enable = true;
    services.blueman.enable = true;
    services.flatpak.enable = true;
    services.logmein-hamachi.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # Or disable the firewall altogether.
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



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
