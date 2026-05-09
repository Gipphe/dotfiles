{ pkgs, util, ... }:
util.mkProgram {
  name = "libgcc";

  home-manager.home.packages = [ pkgs.libgcc ];
}
