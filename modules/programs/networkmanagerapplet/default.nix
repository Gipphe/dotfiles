{ util, pkgs, ... }:
util.mkProgram {
  name = "networkmanagerapplet";
  hm.home.packages = [ pkgs.networkmanagerapplet ];
  systemd.user.services.networkmanagerapplet = {
    Unit = {
      description = "Networkmanager applet";
      PartOf = "graphical-session.target";
    };
    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
