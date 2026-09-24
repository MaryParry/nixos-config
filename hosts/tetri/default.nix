{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
    ../../modules/intel-gpu.nix
  ];

  networking.hostName = "tetri";

  # Laptop LUKS swap device
  boot.initrd.luks.devices."luks-c8724694-43ff-4c8d-9f30-c09fd2e85503".device = "/dev/disk/by-uuid/c8724694-43ff-4c8d-9f30-c09fd2e85503";
}
