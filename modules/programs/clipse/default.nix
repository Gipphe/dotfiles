{
  util,
  config,
  lib,
  ...
}:
util.mkProgram {
  name = "clipse";
  options.gipphe.programs.clipse = {
    hyprland.enable = lib.mkEnableOption "Hyprland integration" // {
      default = config.programs.hyprland.enable;
      defaultText = "config.programs.hyprland.enable";
    };
  };
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
