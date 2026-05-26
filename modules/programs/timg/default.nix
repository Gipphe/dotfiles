{ util, pkgs, ... }:
util.mkProgram {
  name = "timg";
  homeManager.home.packages = [ pkgs.timg ];
}
