{
  den.aspects.programs.hypridle.homeManager =
    { config, ... }:
    let
      hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
    in
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = config.gipphe.core.wm.actions.monitors-on;
            before_sleep_cmd = hyprlock;
            ignore_dbus_inhibit = false;
            lock_cmd = hyprlock;
          };
          listener = [
            {
              timeout = 1200;
              on-timeout = config.gipphe.core.wm.actions.monitors-off;
              on-resume = config.gipphe.core.wm.actions.monitors-on;
            }
          ];
        };
      };
    };
}
