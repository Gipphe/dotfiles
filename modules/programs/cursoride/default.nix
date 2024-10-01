{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "cursoride";
  hm.home.packages = lib.mkIf pkgs.stdenv.isLinux [ pkgs.cursoride ];
  system-darwin.homebrew.casks = [ "cursor" ];
}
