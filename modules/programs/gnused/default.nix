{ pkgs, util, ... }:
util.mkProgram {
  name = "gnused";
  homeManager.home.packages = [ pkgs.gnused ];
}
