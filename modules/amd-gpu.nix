{ pkgs, ... }:

{
  # Early Kernel Mode Setting for AMDGPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-utils
    ];
  };
}
