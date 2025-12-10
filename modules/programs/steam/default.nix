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
  hm = {
    home.packages = [ cfg.package ];
    wayland.windowManager.hyprland.settings.windowrule = [
      "float true, match:class steam, match:title (Friends List)"
    ];
  };
}
