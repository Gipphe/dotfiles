{
  util,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.walker;
  inherit (import ./codes.nix) space;
  defaultConfig = import ./config.nix pkgs;
  writeTOMLFile = (pkgs.formats.toml { }).generate;
in
util.mkProgram {
  name = "walker";
  options.gipphe.programs.walker = {
    package = lib.mkPackageOption pkgs "walker" { };
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = "Settings for walker's config.toml.";
    };
    hyprland.enable = lib.mkEnableOption "hyprland integration" // {
      default = config.programs.hyprland.enable;
      defaultText = "config.programs.hyprland.enable";
    };
  };
  hm = {
    home.packages = [
      cfg.package
      pkgs.libqalculate
    ];
    xdg.configFile = {
      "walker/config.toml".source = writeTOMLFile "walker-config.toml" (
        lib.recursiveUpdate defaultConfig cfg.settings
      );
      "walker/theme" = {
        source = ./themes/default;
        recursive = false;
      };
    };

    gipphe.core.wm.binds = lib.mkIf cfg.hyprland.enable [
      {
        mod = "Mod";
        key = space;
        action.spawn = "${cfg.package}/bin/walker";
      }
      {
        mod = "Mod";
        key = "Tab";
        action.spawn = "${cfg.package}/bin/walker --modules windows";
      }
    ];

    systemd.user.services.walker = {
      Unit = {
        Description = "Walker service for quicker startup";
        Documentation = "https://github.com/abenz1267/walker";
        PartOf = "graphical-session.target";
      };
      Service = {
        ExecStart = "${cfg.package}/bin/walker --gapplication-service";
        Restart = "on-failure";
        RestartSec = "10";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
