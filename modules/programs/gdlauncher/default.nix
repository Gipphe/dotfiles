{ util, pkgs, ... }:
util.mkProgram {
  name = "gdlauncher";
  hm.home.packages = [ pkgs.gdlauncher-carbon ];
}
