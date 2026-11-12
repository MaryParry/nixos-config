{ config, pkgs, inputs, ... }:

let
  # Only the login theme: the rest of whitesur-kde (with the Apple logos swapped
  # out) is installed per-user in home/plasma.nix
  whitesur-sddm = pkgs.runCommand "whitesur-sddm" { } ''
    theme=$out/share/sddm/themes/WhiteSur-dark
    mkdir -p $out/share/sddm/themes
    cp -r ${pkgs.whitesur-kde}/share/sddm/themes/WhiteSur-dark $theme
    chmod -R u+w $theme
    # VirtualKeyboardLoader was dropped from org.kde.breeze.components in
    # Plasma 6.x, and without it the whole theme fails to load. The theme
    # hides its virtual keyboard button anyway, so remove the loader
    sed -i -e '/^        VirtualKeyboardLoader {/,/^        }/d' \
      -e 's/inputPanel\.keyboardActive/false/' \
      -e '/inputPanel\.showHide()/d' $theme/Main.qml
    cp ${../../dotfiles/walls/lock.png} $theme/lock.png
    printf '[General]\ntype=image\nbackground=lock.png\n' > $theme/theme.conf.user
  '';
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/amd-gpu.nix
  ];

  networking.hostName = "alisferi";

  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "WhiteSur-dark";
    extraPackages = with pkgs.kdePackages; [ qt5compat plasma5support ];
  };

  environment.systemPackages = [
    whitesur-sddm
    inputs.kwin-effects-better-blur-dx.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.saponela.imports = [ ../../home/plasma.nix ];
}
