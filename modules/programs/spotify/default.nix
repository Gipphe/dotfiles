{ util, pkgs, ... }:
util.mkProgram {
  name = "spotify";
  home-manager.home.packages = [ pkgs.spotify ];
}
