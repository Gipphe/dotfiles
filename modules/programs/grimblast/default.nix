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
    ];
  };
}
