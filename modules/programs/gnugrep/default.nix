{ util, pkgs, ... }:
util.mkProgram {
  name = "gnugrep";
  home-manager.home.packages = [ pkgs.gnugrep ];
}
