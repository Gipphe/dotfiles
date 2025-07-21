{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.networkmanagerapplet;
in
util.mkProgram {
  name = "networkmanagerapplet";
  options.gipphe.programs.networkmanagerapplet.package =
    lib.mkPackageOption pkgs "networkmanagerapplet"
      { };
  hm = {
    home.packages = [ cfg.package ];
    systemd.user.services.networkmanagerapplet = {
      Unit = {
        description = "Networkmanager applet";
        PartOf = "graphical-session.target";
      };
      Service = {
        ExecStart = "${cfg.package}/bin/nm-applet";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
