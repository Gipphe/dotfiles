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
  homeManager = {
    home.packages = [ cfg.package ];
    gipphe.core.wm.bind = {
      "SUPER + Print".action.spawn = "${grimblast} copy area";
      "SUPER + Alt_L + Print".action.spawn = "${grimblast} copy screen";
    };
  };
}
