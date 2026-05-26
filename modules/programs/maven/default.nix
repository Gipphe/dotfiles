{ util, pkgs, ... }:
util.mkProgram {
  name = "maven";
  homeManager.home.packages = [ pkgs.maven ];
}
