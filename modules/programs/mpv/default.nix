{ pkgs, util, ... }:
util.mkProgram {
  name = "mpv";
  hm.home.packages = [ pkgs.mpv ];
}
