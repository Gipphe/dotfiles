{ util, config, ... }:
let
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
in
util.mkProgram {
  name = "hypridle";
  hm.services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = config.gipphe.core.wm.action.monitors-on;
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
          on-timeout = config.gipphe.core.wm.action.monitors-off;
          on-resume = config.gipphe.core.wm.action.monitors-on;
        }
      ];
    };
  };
}
