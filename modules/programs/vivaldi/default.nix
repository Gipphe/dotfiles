{
  pkgs,
  util,
  lib,
  config,
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
  homeManager = {
    # TODO: Add `--enable-blink-features=MiddleClickAutoscroll` to desktop entry
    home.packages = [ cfg.package ];
    home.sessionVariables = lib.mkIf cfg.default {
      BROWSER = "${cfg.package}/bin/vivaldi";
    };
    gipphe.core.wm.bind = lib.mkIf cfg.default {
      "SUPER + B".action.spawn = "${hmCfg.package}/bin/vivaldi";
    };
  };
}
