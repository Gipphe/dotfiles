{ pkgs, util, ... }:
util.mkProgram {
  name = "vulnix";
  homeManager.home.packages = [ pkgs.vulnix ];
}
