{ util, pkgs, ... }:
util.mkProgram {
  name = "cava";
  hm.home.packages = [ pkgs.cava ];
}
