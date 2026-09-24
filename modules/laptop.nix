{ config, pkgs, lib, ... }:

{
  # Lid switch actions
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };

  # Keyboard remapping via keyd (laptop-specific layout)
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

  # Laptop battery charge threshold configuration (80% limit)
  boot.kernelModules = [ "msi-ec" ];
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
    };
  };
  systemd.tmpfiles.rules = [
    "w- /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    "w- /sys/class/power_supply/BAT1/charge_control_end_threshold - - - - 80"
  ];
}
