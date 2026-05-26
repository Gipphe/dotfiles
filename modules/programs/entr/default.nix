{ util, pkgs, ... }:
util.mkProgram {
  name = "entr";
  homeManager.home.packages = [ pkgs.entr ];
}
