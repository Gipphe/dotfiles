{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.grimblast;
  grimblast = "${cfg.package}/bin/grimblast";
in
util.mkProgram {
  name = "grimblast";
  options.gipphe.programs.grimblast = {
    package = lib.mkPackageOption pkgs "grimblast" { };
    logi-mx-keys = lib.mkEnableOption "add keybinds for Logi MX Keys";
  };
  hm = {
    home.packages = [ cfg.package ];
    wayland.windowManager.hyprland.settings.bind =
      [
        ", Print, exec, ${grimblast} copy area"
        "Alt_L, Print, exec, ${grimblast} copy screen"
      ]
      ++ lib.optionals cfg.logi-mx-keys [
        # Logitech MX Keys screenshot hotkey sends SUPER_L+SHIFT_L+S
        "SUPER_L SHIFT_L, S, exec, ${grimblast} copy area"
        "SUPER_L SHIFT_L ALT_L, S, exec, ${grimblast} copy screen"
      ];
  };
}
