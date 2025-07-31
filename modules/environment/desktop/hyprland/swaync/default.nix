{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.environment.desktop.hyprland.swaync;
  hmCfg = config.services.swaync;
  jsonFormat = pkgs.formats.json { };
  settingsFile = jsonFormat.generate "swaync-config.json" cfg.settings;
  styleFile = pkgs.writeText "swaync-style.css" cfg.style;
  package = pkgs.symlinkJoin {
    name = "swaync";
    paths = [ pkgs.swaynotificationcenter ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/swaync --add-flags "--config '${settingsFile}' --style '${styleFile}'"
    '';
  };
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "swaync";
  options.gipphe.environment.desktop.hyprland.swaync = {
    package = lib.mkPackageOption pkgs "swaync" {
      default = [ "swaynotificationcenter" ];
    };
    style = lib.mkOption {
      type = with lib.types; nullOr (either path lines);
      default = null;
      description = ''
        CSS style of the bar. See
        <https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/style.css>
        for the documentation.

        If the value is set to a path literal, then the path will be used as the CSS file.
      '';
    };
    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Configuration file for swaync.
        See
        <https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/configSchema.json>
        for the documentation.
      '';
    };
  };
  hm = {
    gipphe.environment.desktop.hyprland.swaync = {
      settings = {
        widgets = [
          "title"
          "menubar"
          "dnd"
          "inhibitors"
          "notifications"
        ];
      };
      style = hmCfg.style;
    };
    home.packages = [ package ];
    systemd.user.services.swaync = {
      Unit = {
        Description = "Sway Notification Center daemon";
        Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${package}/bin/swaync";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
