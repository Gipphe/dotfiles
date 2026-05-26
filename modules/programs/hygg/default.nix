{ pkgs, util, ... }:
util.mkProgram {
  name = "hygg";
  homeManager.home.packages = [ pkgs.hygg ];
}
