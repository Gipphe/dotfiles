{ util, pkgs, ... }:
util.mkProgram {
  name = "gimp";
  homeManager.home.packages = [ pkgs.gimp-with-plugins ];
}
