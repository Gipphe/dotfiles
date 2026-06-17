{
  inputs,
  # osConfig,
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

    # TODO: fix this
    # Fix slow steam client downloads https://redd.it/16e1l4h
    # Speed up shader processing by using more than a single thread
    # xdg.configFile."Steam/steam_dev.cfg".text = ''
    #   @nClientDownloadEnableHTTP2PlatformLinux 0
    #   unShaderBackgroundProcessingThreads ${toString (builtins.head osConfig.hardware.facter.report.hardware.cpu).siblings}
    # '';
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
