{ pkgs, util, ... }:
util.mkProgram {
  name = "libgcc";

  hm.home.packages = [ pkgs.libgcc ];
}
