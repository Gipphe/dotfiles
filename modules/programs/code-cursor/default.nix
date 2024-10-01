{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "code-cursor";
  hm.home.packages = lib.mkIf pkgs.stdenv.isLinux [ pkgs.cursoride ];
  system-darwin.homebrew.casks = [ "cursor" ];
}
