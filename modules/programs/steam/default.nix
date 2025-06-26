{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.steam;
in
util.mkProgram {
  name = "steam";
  options.gipphe.programs.steam.package = lib.mkPackageOption pkgs "steam" { };
  hm.home.packages = [ cfg.package ];
  system-darwin.homebrew.casks = [ "steam" ];
}
