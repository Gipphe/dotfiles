{ util, pkgs, ... }:
util.mkProgram {
  name = "wiremix";
  homeManager.home.packages = [ pkgs.wiremix ];
}
