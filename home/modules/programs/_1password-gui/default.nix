{
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "_1password-gui";
  hm = lib.mkIf (pkgs.stdenv.isLinux) { home.packages = with pkgs; [ _1password-gui ]; };
  system-darwin.homebrew.casks = [ "1password" ];
}
