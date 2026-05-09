{ util, pkgs, ... }:
util.mkProgram {
  name = "maven";
  home-manager.home.packages = [ pkgs.maven ];
}
