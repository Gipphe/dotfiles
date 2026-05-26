{ util, config, ... }:
util.mkProgram {
  name = "clipse";
  homeManager = {
    services.clipse = {
      enable = true;
    };
    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "V";
        action.spawn = "${config.programs.wezterm.package}/bin/wezterm start --class clipse clipse";
      }
    ];
    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.class = "clipse";
        float = true;
        size = [
          622
          652
        ];
        stay_focused = true;
      }
    ];
  };
}
