{
  util,
  pkgs,
  lib,
  ...
}:
let
  pkg = pkgs.steam.override {
    extraArgs = "-system-composer";
  };
in
util.mkProgram {
  name = "steam";
  options.gipphe.programs.steam.package = lib.mkPackageOption pkgs "steam" { } // {
    default = pkg;
  };
  hm = {
    wayland.windowManager.hyprland.settings.windowrule = [
      "float true, match:class steam, match:title (Friends List)"
    ];
    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            app-id = "steam";
            title = "^notificationtoasts_\\d+_desktop$";
          }
        ];
        default-floating-position = {
          relative-to = "bottom-right";
          x = 10;
          y = 10;
        };
      }
    ];
  };
  system-nixos = {
    programs.steam = {
      enable = true;
      package = pkg;
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamescope.enable = true;
  };
}
