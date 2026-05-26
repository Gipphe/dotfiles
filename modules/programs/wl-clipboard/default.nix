{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.wl-clipboard;
in
util.mkProgram {
  name = "wl-clipboard";
  options.gipphe.programs.wl-clipboard.package = lib.mkPackageOption pkgs "wl-clipboard" { };
  homeManager = {
    home.packages = [ cfg.package ];
  };
}
