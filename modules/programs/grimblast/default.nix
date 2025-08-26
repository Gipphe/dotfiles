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
    gipphe.core.wm.binds = [
      {
        key = "Print";
        action.spawn = "${grimblast} copy area";
      }
      {
        mod = "Alt_L";
        key = "Print";
        action.spawn = "${grimblast} copy screen";
      }
    ]
    ++ lib.optionals cfg.logi-mx-keys [
      # Logitech MX Keys screenshot hotkey sends SUPER_L+SHIFT_L+S
      {
        mod = [
          "SUPER_L"
          "SHIFT_L"
        ];
        key = "S";
        action.spawn = "${grimblast} copy area";
      }
      {
        mod = [
          "SUPER_L"
          "SHIFT_L"
          "ALT_L"
        ];
        key = "S";
        action.spawn = "${grimblast} copy screen";
      }
    ];
  };
}
