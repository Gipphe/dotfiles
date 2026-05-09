{ util, pkgs, ... }:
util.mkProgram {
  name = "glow";
  home-manager.home.packages = [ pkgs.glow ];
}
