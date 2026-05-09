{ util, pkgs, ... }:
util.mkProgram {
  name = "pinentry-curses";
  home-manager.home.packages = [ pkgs.pinentry-curses ];
}
