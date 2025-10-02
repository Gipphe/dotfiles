{ util, pkgs, ... }:
util.mkProgram {
  name = "vhs";
  hm.home.packages = [ pkgs.vhs ];
}
