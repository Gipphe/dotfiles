{ pkgs, util, ... }:
util.mkProgram {
  name = "libgcc";

  hm.home.packages = with pkgs; [ libgcc ];
}
