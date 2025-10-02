{ util, pkgs, ... }:
util.mkProgram {
  name = "imagemagick";
  hm.home.packages = [ pkgs.imagemagick ];
}
