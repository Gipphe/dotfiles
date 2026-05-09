{ util, pkgs, ... }:
util.mkProgram {
  name = "fx";
  home-manager.home.packages = [ pkgs.fx ];
}
