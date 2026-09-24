{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/amd-gpu.nix
  ];

  networking.hostName = "alisferi";
}
