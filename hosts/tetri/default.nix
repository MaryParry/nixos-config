{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
    ../../modules/intel-gpu.nix
  ];

  networking.hostName = "tetri";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    # GNOME Essentials (extensions live in home/gnome.nix -> programs.gnome-shell)
    gnome-tweaks
    gnome-extension-manager
    dconf-editor
    file-roller
  ];

  home-manager.users.saponela.imports = [ ../../home/gnome.nix ];

  # Laptop LUKS swap device
  boot.initrd.luks.devices."luks-c8724694-43ff-4c8d-9f30-c09fd2e85503".device = "/dev/disk/by-uuid/c8724694-43ff-4c8d-9f30-c09fd2e85503";
}
