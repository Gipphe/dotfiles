{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.wl-clipboard;
in
util.mkProgram {
  name = "wl-clipboard";
  options.gipphe.programs.wl-clipboard.package = lib.mkPackageOption pkgs "wl-clipboard" { };
  hm = {
    home.packages = [ cfg.package ];
    systemd.user.services.wl-clipboard = {
      Unit = {
        Description = "Synchronizes clipboard contents between applications";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/wl-paste --primary --watch ${cfg.package}/bin/wl-copy";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
