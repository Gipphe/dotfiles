{ util, pkgs, ... }:
util.mkProgram {
  name = "unzip";
  homeManager.home.packages = [ pkgs.unzip ];
}
