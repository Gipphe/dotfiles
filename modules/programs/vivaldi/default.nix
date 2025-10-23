{
  pkgs,
  util,
  lib,
  config,
  flags,
  ...
}:
let
  cfg = config.gipphe.programs.vivaldi;
  hmCfg = config.programs.vivaldi;
in
util.mkProgram {
  name = "vivaldi";
  options.gipphe.programs.vivaldi = {
    package = lib.mkPackageOption pkgs "vivaldi" { };
    default = lib.mkEnableOption "Vivaldi as default browser";
  };
  hm = lib.optionalAttrs (!flags.isNixDarwin) {
    home.packages = [ cfg.package ];
    home.sessionVariables = lib.mkIf cfg.default {
      BROWSER = "${cfg.package}/bin/vivaldi";
    };
    gipphe.core.wm.binds = lib.mkIf cfg.default [
      {
        mod = "Mod";
        key = "B";
        action.spawn = "${hmCfg.package}/bin/vivaldi";
      }
    ];
  };
}
