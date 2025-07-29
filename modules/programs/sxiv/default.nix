{ util, pkgs, ... }:
util.mkProgram {
  name = "sxiv";
  hm.home.packages = [ pkgs.sxiv ];
}
