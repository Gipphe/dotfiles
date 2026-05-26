{ util, pkgs, ... }:
util.mkProgram {
  name = "asciinema-agg";
  homeManager.home.packages = [ pkgs.asciinema-agg ];
}
