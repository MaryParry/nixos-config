{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # For VA-API (video acceleration)
      intel-vaapi-driver # Formerly vaapiIntel
      libvdpau-va-gl
    ];
  };
}
