{ util, pkgs, ... }:
util.mkProgram {
  name = "fx";
  homeManager.home.packages = [ pkgs.fx ];
}
