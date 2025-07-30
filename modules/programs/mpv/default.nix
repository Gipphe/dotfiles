{ pkgs, util, ... }:
util.mkProgram {
  name = "mpv";
  hm.programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
