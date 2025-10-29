{ pkgs, util, ... }:
util.mkProgram {
  name = "gnused";
  hm.home.packages = [ pkgs.gnused ];
}
