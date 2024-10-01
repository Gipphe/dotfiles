{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "code-cursor";
  hm.home.packages = lib.mkIf pkgs.stdenv.isLinux [ pkgs.code-cursor ];
  system-darwin.homebrew.casks = [ "cursor" ];
}
