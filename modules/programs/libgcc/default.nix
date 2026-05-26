{ pkgs, util, ... }:
util.mkProgram {
  name = "libgcc";

  homeManager.home.packages = [ pkgs.libgcc ];
}
