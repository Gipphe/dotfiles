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
  hm = {
    home.packages = [ cfg.package ];
    home.sessionVariables = lib.mkIf cfg.default {
      BROWSER = "${cfg.package}/bin/vivaldi";
    };
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, B, exec, ${hmCfg.package}/bin/vivaldi # Opens the browser"
    ];
  };
}
