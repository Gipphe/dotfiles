{ util, pkgs, ... }:
util.mkProgram {
  name = "pv";
  hm.home.packages = [ pkgs.pv ];
}
