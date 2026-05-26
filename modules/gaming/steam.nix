{
  inputs,
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
    ];
  };
  shared.gipphe.gaming.gamescope.enable = true;
  nixos = {
    programs.steam = {
      enable = true;
      package = pkg;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [
        inputs.nix-gaming-edge.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3
        pkgs.proton-ge-bin
      ];
    };
  };
}
