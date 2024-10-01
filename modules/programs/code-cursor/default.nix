{
  util,
  pkgs,
  lib,
  ...
}:
util.mkProgram {
  name = "code-cursor";
  hm.home.packages = lib.mkIf pkgs.stdenv.isLinux [
    (pkgs.writeShellScriptBin "cursor" ''
      ${pkgs.code-cursor}/bin/cursor "$@" &>/dev/null &
    '')
  ];
  system-darwin.homebrew.casks = [ "cursor" ];
}
