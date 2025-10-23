{ pkgs, util, ... }:
util.mkProgram {
  name = "filen-desktop";
  hm.home.packages = [ pkgs.filen-desktop ];
}
