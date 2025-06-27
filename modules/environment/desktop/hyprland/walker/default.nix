{
  util,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.gipphe.environment.desktop.hyprland.walker;
  inherit (import ../codes.nix) space;
  defaultConfig = import ./config.nix pkgs;
  writeTOMLFile = (pkgs.formats.toml { }).generate;
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "walker";
  options.gipphe.environment.desktop.hyprland.walker = {
    package = lib.mkPackageOption pkgs "walker" { };
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = "Settings for walker's config.toml.";
    };
  };
  hm = {
    home.packages = [ cfg.package ];
    xdg.configFile = {
      "walker/config.toml".source = writeTOMLFile "walker-config.toml" (
        lib.recursiveUpdate defaultConfig cfg.settings
      );
      "walker/theme" = {
        source = ./themes/default;
        recursive = false;
      };
    };

    wayland.windowManager.hyprland.settings.bind = [
      "$mod, ${space}, exec, ${cfg.package}/bin/walker"
      "$mod, Tab, exec, ${cfg.package}/bin/walker --modules windows"
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
