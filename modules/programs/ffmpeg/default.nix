{ util, pkgs, ... }:
util.mkProgram {
  name = "ffmpeg";
  hm.home.packages = [ pkgs.ffmpeg ];
}
