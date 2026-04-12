{ pkgs, util, ... }:
util.mkProgram {
  name = "filen-desktop";
  hm = {
    home.packages = [ pkgs.filen-desktop ];
    systemd.user.services.filen-startup = {
      Unit.Description = "Start Filen on boot";
      Service.Type = "oneshot";
      Service.ExecStart = "${pkgs.filen-desktop}/bin/filen-desktop";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
