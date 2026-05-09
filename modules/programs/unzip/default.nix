{ util, pkgs, ... }:
util.mkProgram {
  name = "unzip";
  home-manager.home.packages = [ pkgs.unzip ];
}
