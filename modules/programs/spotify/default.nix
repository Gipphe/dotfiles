{ util, pkgs, ... }:
util.mkProgram {
  name = "spotify";
  hm.home.packages = [ pkgs.spotify ];
}
