{ util, pkgs, ... }:
util.mkProgram {
  name = "pinentry-curses";
  hm.home.packages = [ pkgs.pinentry-curses ];
  hm.gipphe.default.pinentry = {
    name = "pinentry-curses";
    package = pkgs.pinentry-curses;
    actions.open = "${pkgs.pinentry-curses}/bin/pinentry-curses";
  };
}
