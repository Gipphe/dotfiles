{ util, pkgs, ... }:
util.mkProgram {
  name = "gimp";
  home-manager.home.packages = [ pkgs.gimp-with-plugins ];
}
