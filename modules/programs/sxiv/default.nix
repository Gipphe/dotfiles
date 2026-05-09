{ util, pkgs, ... }:
util.mkProgram {
  name = "sxiv";
  home-manager.home.packages = [ pkgs.sxiv ];
}
