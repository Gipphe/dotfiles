{ util, pkgs, ... }:
util.mkProgram {
  name = "asciinema-agg";
  hm.home.packages = [ pkgs.asciinema-agg ];
}
