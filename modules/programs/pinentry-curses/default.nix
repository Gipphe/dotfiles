{ util, pkgs, ... }:
util.mkProgram {
  name = "pinentry-curses";
  homeManager.home.packages = [ pkgs.pinentry-curses ];
}
