{ util, pkgs, ... }:
util.mkProgram {
  name = "pv";
  home-manager.home.packages = [ pkgs.pv ];
}
