{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  configFile = pkgs.writeText "swaync-config.json" (
    builtins.toJSON {
      widgets = [
        "title"
        "menubar"
        "dnd"
        "volume"
        "backlight"
        "inhibitors"
        "notifications"
      ];
    }
  );
  styleFile = pkgs.runCommand "swaync-style.css" { } ''
    ${pkgs.dart-sass}/bin/sass --no-source-map ${./style.scss} "$out"
  '';
  package = pkgs.symlinkJoin {
    name = "swaync";
    paths = [ pkgs.swaynotificationcenter ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/swaync --add-flags "--config '${configFile}' --style '${styleFile}'"
    '';
  };
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "swaync";
  options.gipphe.environmnet.desktop.hyprland.swaync = {
    package = lib.mkPackageOption pkgs "swaync" {
      default = [ "swaynotificationcenter" ];
    };
  };
  hm = {
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
