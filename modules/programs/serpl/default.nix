{ util, pkgs, ... }:
util.mkProgram {
  name = "serpl";
  homeManager.home.packages = [ pkgs.serpl ];
}
