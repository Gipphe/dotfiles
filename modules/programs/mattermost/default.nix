{
  util,
  pkgs,
  lib,
  ...
}:
let
  pkg = pkgs.mattermost-desktop;
in
util.mkProgram {
  name = "mattermost";
  hm = {
    home.packages = [ pkgs.mattermost-desktop ];
    wayland.windowManager.hyprland.settings.bind = [
      "$mod, M, exec, ${lib.getExe pkg}"
    ];
  };
}
