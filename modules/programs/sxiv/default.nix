{ util, pkgs, ... }:
util.mkProgram {
  name = "sxiv";
  homeManager.home.packages = [ pkgs.sxiv ];
}
