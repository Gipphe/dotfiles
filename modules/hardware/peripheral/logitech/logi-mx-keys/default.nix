{
  util,
  lib,
  config,
  ...
}:
let
  grimblastCfg = config.gipphe.programs.grimblast;
  grimblast = lib.getExe grimblastCfg.package;
in
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "logi-mx-keys";
  homeManager.config = lib.mkIf grimblastCfg.enable {
    gipphe.core.wm.bind = {
      # Logitech MX Keys screenshot hotkey sends SUPER_L+SHIFT_L+S
      "SUPER_L + SHIFT_L + S".action.spawn = "${grimblast} copy area";
      "SUPER_L + SHIFT_L + ALT_L + S".action.spawn = "${grimblast} copy screen";
    };
  };
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
  };
}
