{ util, pkgs, ... }:
util.mkProgram {
  name = "imagemagick";
  homeManager.home.packages = [ pkgs.imagemagick ];
}
