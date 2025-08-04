{ util, config, ... }:
util.mkProgram {
  name = "clipse";
  hm = {
    services.clipse = {
      enable = true;
    };
    wayland.windowManager.hyprland.settings = {
      windowrule = [
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
        "stayfocused, class:(clipse)"
      ];
      bind = [
        "$mod, V, exec, ${config.programs.wezterm.package}/bin/wezterm start --class clipse clipse"
      ];
    };
  };
}
