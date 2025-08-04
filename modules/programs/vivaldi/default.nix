{
  pkgs,
  util,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.vivaldi;
in
util.mkProgram {
  name = "vivaldi";
  options.gipphe.programs.vivaldi = {
    package = lib.mkPackageOption pkgs "vivaldi" { };
    default = lib.mkEnableOption "Vivaldi as default browser";
  };
  hm = {
    home.packages = [ pkgs.vivaldi ];
    gipphe.default.browser = lib.mkIf cfg.default {
      name = "Vivaldi";
      inherit (cfg) package;
      actions.open = "${cfg.package}/bin/vivaldi";
    };
  };
}
