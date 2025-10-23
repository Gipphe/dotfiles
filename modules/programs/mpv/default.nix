{
  pkgs,
  util,
  lib,
  flags,
  ...
}:
util.mkProgram {
  name = "mpv";
  hm.programs.mpv = lib.optionalAttrs (!flags.isNixDarwin) {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
