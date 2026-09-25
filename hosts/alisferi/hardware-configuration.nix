# Hardware configuration for 'alisferi' (Desktop PC)
# Generated from /etc/nixos/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-03d8ea75-ea55-4b49-bcb0-4cccaadbd425";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."luks-03d8ea75-ea55-4b49-bcb0-4cccaadbd425".device = "/dev/disk/by-uuid/03d8ea75-ea55-4b49-bcb0-4cccaadbd425";

  fileSystems."/nix" = {
    device = "/dev/mapper/luks-03d8ea75-ea55-4b49-bcb0-4cccaadbd425";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0551-4525";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/luks-5f9087e6-961b-430c-8e91-33f6e5eee7bb";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."luks-5f9087e6-961b-430c-8e91-33f6e5eee7bb".device = "/dev/disk/by-uuid/5f9087e6-961b-430c-8e91-33f6e5eee7bb";

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.enable = true;
}

