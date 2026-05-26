{ util, pkgs, ... }:
util.mkProgram {
  name = "pv";
  homeManager.home.packages = [ pkgs.pv ];
}
