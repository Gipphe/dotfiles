{ util, pkgs, ... }:
util.mkProgram {
  name = "pinentry-curses";
  hm.home.packages = [ pkgs.pinentry-curses ];
}
