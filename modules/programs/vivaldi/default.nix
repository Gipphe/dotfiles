{
  lib,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "vivaldi";
  shared.imports = [ ./css ];
  hm = {
    home.packages = [ (lib.mkIf pkgs.stdenv.isLinux pkgs.vivaldi) ];
  };
  system-darwin.homebrew.casks = [ "vivaldi" ];
}
