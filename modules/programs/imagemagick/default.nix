{ util, pkgs, ... }:
util.mkProgram {
  name = "imagemagick";
  home-manager.home.packages = [ pkgs.imagemagick ];
}
