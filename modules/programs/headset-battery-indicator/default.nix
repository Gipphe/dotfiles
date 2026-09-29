{
  self,
  lib,
  util,
  pkgs,
  ...
}:
let
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.headset-battery-indicator;
in
util.mkProgram {
  name = "headset-battery-indicator";
  homeManager = {
    home.packages = [ pkg ];
    systemd.user.services.headset-battery-indicator = {
      Unit = {
        Description = "Headset battery indicator";
        Requires = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = lib.getExe pkg;
        Restart = "on-failure";
        RestartSteps = 3;
        RestartMaxDelaySec = 6;
      };
    };
  };
  nixos = {
    environment.systemPackages = [ pkgs.headsetcontrol ];
  };
}
