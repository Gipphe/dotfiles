{ util, pkgs, ... }:
util.mkProgram {
  name = "glow";
  hm.home.packages = [ pkgs.glow ];
}
