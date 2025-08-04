{ util, config, ... }:
let
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
in
util.mkProgram {
  name = "hypridle";
  hm.services.hypridle = {
    inherit (config.gipphe.programs.hyprland) enable;
    settings = {
      general = {
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
        before_sleep_cmd = hyprlock;
        ignore_dbus_inhibit = false;
        lock_cmd = hyprlock;
      };
      listener = [
        {
          timeout = 900;
          on-timeout = hyprlock;
        }
        {
          timeout = 1200;
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        }
      ];
    };
  };
}
