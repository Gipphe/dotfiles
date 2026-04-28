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
    gipphe.programs.hyprland.settings.windowRules = [
      {
        match.title = "Friends List";
        match.class = "steam";
        float = true;
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
