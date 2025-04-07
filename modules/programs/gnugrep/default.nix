{ util, pkgs, ... }:
util.mkProgram {
  name = "gnugrep";
  hm.home.packages = [ pkgs.gnugrep ];
}
