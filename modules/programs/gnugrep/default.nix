{ util, pkgs, ... }:
util.mkProgram {
  name = "gnugrep";
  homeManager.home.packages = [ pkgs.gnugrep ];
}
