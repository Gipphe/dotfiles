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
    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "V";
        action.spawn = "${config.programs.wezterm.package}/bin/wezterm start --class clipse clipse";
      }
    ];
    gipphe.programs.hyprland.settings.windowRules = [
      {
        match.class = "eclipse";
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
