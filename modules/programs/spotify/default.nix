{ util, pkgs, ... }:
util.mkProgram {
  name = "spotify";
  homeManager.home.packages = [ pkgs.spotify ];
}
