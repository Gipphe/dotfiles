{ util, pkgs, ... }:
util.mkProgram {
  name = "glow";
  homeManager.home.packages = [ pkgs.glow ];
}
