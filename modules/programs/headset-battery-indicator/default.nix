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
    gipphe.core.wm.triggers.on-startup.headset-battery-indicator.command = lib.getExe pkg;
  };
  nixos = {
    environment.systemPackages = [ pkgs.headsetcontrol ];
  };
}
