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
util.mkGaming {
  name = "steam";
  options.gipphe.programs.steam.package = lib.mkPackageOption pkgs "steam" { } // {
    default = pkg;
  };
  homeManager = {
    wayland.windowManager.hyprland.settings.window_rule = [
      {
        match.title = "Friends List";
        match.class = "steam";
        float = true;
      }
      {
        match.initial_class = "steam_app_.+";
        fullscreen = true;
      }
    ];
    xdg.configFile."autostart/steam.desktop".source = "${
      pkgs.callPackage ./autostart.nix { }
    }/share/applications/steam-autostart.desktop";
  };
  shared.gipphe.gaming.gamescope.enable = true;
  nixos = {
    programs.steam = {
      enable = true;
      package = pkg;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };
}
